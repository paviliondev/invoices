class Common < ActiveRecord::Base
  include Wisper::Publisher
  include MetaAttributes
  include ModelCsv

  # Behaviors
  acts_as_taggable
  acts_as_paranoid

  # Relations
  belongs_to :customer, optional: true
  belongs_to :series
  belongs_to :print_template,
    :class_name => 'Template',
    :foreign_key => 'print_template_id',
    optional: true
  belongs_to :email_template,
    :class_name => 'Template',
    :foreign_key => 'email_template_id',
    optional: true
  has_many :items, -> {order(id: :asc)}, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :items,
    :reject_if => :all_blank,
    :allow_destroy => true
  has_many :common_payment_receivers, dependent: :destroy
  has_many :payment_receivers, through: :common_payment_receivers
  
  # Validations
  validate :valid_customer_identification
  validates :series, presence: true
  validates :email,
    format: {with: /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i,
             message: "Only valid emails"}, allow_blank: true

  # Events
  after_save :purge_items
  after_save :update_amounts
  after_initialize :init

  # Search
  scope :with_terms, ->(terms) {
    return nil if terms.empty?
    joins(:items).where('name ILIKE :terms OR
           email ILIKE :terms OR
           identification ILIKE :terms OR
           description ILIKE :terms',
           terms: "%#{terms}%")
  }

  CSV_FIELDS = [
    "id", "customer_id", "name",
    "identification", "email",
    "invoicing_address", "shipping_address",
    "contact_person", "terms",
    "notes", "currency",
    "net_amount", "tax_amount", "gross_amount",
    "draft", "sent_by_email",
    "created_at", "updated_at",
    "print_template_id"
  ]

  def init
    begin
      # Set defaults
      unless self.id
        self.series ||= Series.default
        self.terms ||= Settings.legal_terms
        self.currency ||= Settings.currency
      end
    # Using scope.select also triggers this init method
    # so we have to deal with this exception
    rescue ActiveModel::MissingAttributeError
    end
  end

  # A hash with each tax amount rounded
  def taxes
    # Get taxes_hash for each item
    tax_hashes = items.each.map {|item| item.taxes_hash}
    # Sum and merge them
    taxes = tax_hashes.inject({}) do |memo, el|
      memo.merge(el){|k, old_v, new_v| old_v + new_v}
    end
    # Round of taxes is made over total of each tax
    taxes.each do |tax, amount|
      taxes[tax] = amount.round(currency_precision)
    end
  end

  def have_items_discount?
    items.each do |item|
      if item.discount > 0
        return true
      end
    end
    false
  end

  # Total taxes amount added up
  def tax_amount
    self.taxes.values.reduce(0, :+)
  end

  # restore if soft deleted, along with its items
  def back_from_death
    restore! recursive: true
  end

  # Returns the invoice template if set, and the default otherwise
  def get_print_template
    return self.print_template ||
      Template.find_by(print_default: true) ||
      Template.first
  end

  # Returns the invoice template if set, and the default otherwise
  def get_email_template
    return self.email_template ||
      Template.find_by(email_default: true) ||
      Template.first
  end

  def set_amounts
    self.net_amount = items.reduce(0) {|sum, item| sum + item.net_amount}
    self.gross_amount = net_amount + tax_amount
  end

  def update_amounts
    set_amounts
    # Use update_columns to skip more callbacks
    self.update_columns(net_amount: self.net_amount, gross_amount: self.gross_amount)
  end

  # make sure every soft-deleted item is really destroyed
  def purge_items
    items.only_deleted.delete_all
  end

  # csv format
  def self.csv(results)
    csv_stream(results, self::CSV_FIELDS, results.meta_attributes_keys)
  end

  # Triggers an event via Wisper
  def trigger_event(event)
    broadcast(event, self)
  end

  def get_currency
    Money::Currency.find currency
  end

  def currency_precision
    get_currency.exponent
  end

protected

  # Declare scopes for search
  def self.ransackable_scopes(auth_object = nil)
    [:with_terms]
  end

private

  def valid_customer_identification
    unless name? or identification?
      errors.add :base, "Customer name or identification is required."
    end
  end

end

# == Schema Information
#
# Table name: commons
#
#  id                   :bigint           not null, primary key
#  contact_person       :string(100)
#  currency             :string(3)
#  days_to_due          :integer
#  deleted_at           :datetime
#  deleted_number       :integer
#  draft                :boolean          default(FALSE)
#  due_date             :date
#  email                :string(100)
#  enabled              :boolean          default(TRUE)
#  failed               :boolean          default(FALSE)
#  finishing_date       :date
#  gross_amount         :decimal(53, 15)  default(0.0)
#  identification       :string(50)
#  invoicing_address    :text
#  issue_date           :date
#  max_occurrences      :integer
#  meta_attributes      :text
#  must_occurrences     :integer
#  name                 :string(100)
#  net_amount           :decimal(53, 15)  default(0.0)
#  notes                :text
#  number               :integer
#  paid                 :boolean          default(FALSE)
#  paid_amount          :decimal(53, 15)  default(0.0)
#  period               :integer
#  period_type          :string(8)
#  sent_by_email        :boolean          default(FALSE)
#  shipping_address     :text
#  starting_date        :date
#  terms                :text
#  type                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  customer_id          :integer          not null
#  email_template_id    :integer
#  print_template_id    :integer
#  recurring_invoice_id :integer
#  series_id            :integer
#
# Indexes
#
#  cntct_idx                              (contact_person)
#  common_deleted_number_idx              (series_id,deleted_number)
#  common_recurring_invoice_id_common_id  (recurring_invoice_id)
#  common_type_idx                        (type)
#  common_unique_number_idx               (series_id,number) UNIQUE
#  cstid_idx                              (identification)
#  cstml_idx                              (email)
#  cstnm_idx                              (name)
#  customer_id_idx                        (customer_id)
#  index_commons_on_deleted_at            (deleted_at)
#  series_id_idx                          (series_id)
#  type_and_status_idx                    (type)
#
