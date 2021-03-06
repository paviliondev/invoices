class Customer < ActiveRecord::Base
  include MetaAttributes
  include ModelCsv

  acts_as_paranoid
  has_many :invoices
  has_many :estimates
  has_many :recurring_invoices
  has_many :users

  # Validation
  validate :valid_customer_identification
  validates_uniqueness_of :name,  scope: :identification

  # Behaviors
  acts_as_taggable

  before_destroy :check_invoices

  CSV_FIELDS = [
    "id", "name", "identification", "email", "contact_person",
    "invoicing_address", "shipping_address", "meta_attributes",
    "active"
  ]

  scope :with_terms, ->(terms) {
    return nil if terms.empty?
    where('name ILIKE :terms OR email ILIKE :terms OR identification ILIKE :terms', terms: '%' + terms + '%')
  }

  scope :only_active, ->(boolean = true) {
    return nil unless boolean
    where(active: true)
  }

  def total
    invoices.where(draft: false, failed: false).sum :gross_amount || 0
  end

  def paid
    invoices.where(draft: false, failed: false).sum :paid_amount || 0
  end

  def due
    total - paid
  end

  def to_s
    if name?
      name
    elsif identification?
      identification
    elsif email?
      email
    else
      'Customer'
    end
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, *(attribute_names - ["name_slug", "deleted_at"]))
    end
  end

  # csv format
  def self.csv(results)
    csv_stream(results, self::CSV_FIELDS, results.meta_attributes_keys)
  end


private

  def check_invoices
    if self.total > self.paid
      errors[:base] << "This customer can't be deleted because it has unpaid invoices"
      throw(:abort)
    end
  end

  def self.ransackable_scopes(auth_object = nil)
    [:with_terms, :only_active]
  end

  def valid_customer_identification
    unless name? or identification?
      errors.add :base, "Name or identification is required."
    end
  end

end

# == Schema Information
#
# Table name: customers
#
#  id                :bigint           not null, primary key
#  active            :boolean          default(TRUE)
#  contact_person    :string(100)
#  deleted_at        :datetime
#  email             :string(100)
#  group             :string
#  identification    :string(50)
#  invoicing_address :text
#  meta_attributes   :text
#  name              :string(100)
#  name_slug         :string(100)
#  shipping_address  :text
#
# Indexes
#
#  cstm_slug_idx                  (name_slug) UNIQUE
#  index_customers_on_deleted_at  (deleted_at)
#
