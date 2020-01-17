class RecurringInvoice < Common
  # Relations
  has_many :invoices

  # Validation
  validates :starting_date, presence: true
  validates :period_type, presence: true
  validates :period, presence: true,
            numericality: {only_integer: true, greater_than: 0}
  validate :valid_date_range

  PERIOD_TYPES = [
    ["Daily", "day"],
    ["Monthly", "month"],
    ["Yearly", "year"]
  ].freeze

  CSV_FIELDS = Common::CSV_FIELDS + ["series", "days_to_due", "enabled",
    "max_occurrences", "must_occurrences", "period", "period_type",
    "starting_date", "finishing_date"]

  # acts_as_paranoid behavior
  def paranoia_destroy_attributes
    {
      deleted_at: current_time_from_proper_timezone,
      enabled: false
    }
  end

  def to_s
    "#{name}"
  end

  # Returns the issue date of the next invoice that must be generated
  def next_invoice_date
    self.invoices.length > 0 ? self.invoices.order(:id).last.issue_date + period.send(period_type) : starting_date
  end

  # Returns the list of issue dates for all pending invoices
  def next_occurrences
    result = []

    occurrences = Invoice.belonging_to(id).count
    next_date = next_invoice_date
    max_date = [Date.current, finishing_date.blank? ? Date.current + 1 : finishing_date].min

    while next_date <= max_date and (max_occurrences.nil? or occurrences < max_occurrences) do
      result.append(next_date)
      occurrences += 1
      next_date += period.send period_type
    end

    result
  end

  # Returns a list of (not-yet-saved) pending invoices for this instance.
  def build_pending_invoices
    next_occurrences.map do |issue_date|
      invoice = self.becomes(Invoice).dup
      
      invoice.period = nil
      invoice.period_type = nil
      invoice.starting_date = nil
      invoice.finishing_date = nil
      invoice.max_occurrences = nil

      self.items.each do |item|
        nitem = Item.new(item.attributes)
        nitem.id = nil
        item.taxes.each do |tax|
          nitem.taxes << tax
        end
        invoice.items << nitem
      end

      invoice.recurring_invoice = self
      invoice.issue_date = issue_date
      invoice.due_date = invoice.issue_date + days_to_due.days if days_to_due
      invoice.sent_by_email = false
      invoice.meta_attributes = meta_attributes

      invoice.items.each do |item|
        item.description.sub! "$(issue_date)", invoice.issue_date.strftime('%Y-%m-%d')
        item.description.sub! "$(issue_date - period)", (invoice.issue_date - period.send(period_type)).strftime('%Y-%m-%d')
        item.description.sub! "$(issue_date + period)", (invoice.issue_date + period.send(period_type)).strftime('%Y-%m-%d')
      end

      invoice
    end
  end

  # Builds and save ordered (by issue date) all pending invoices for all the
  # enabled recurring invoices.
  def self.build_pending_invoices!
    invoices = []

    where(:enabled => true).where("starting_date <= ?", Date.current).each do |r_inv|
      invoices += r_inv.build_pending_invoices
    end

    invoices.sort_by!(&:issue_date)

    invoices.each do |invoice|
      if invoice.save
        invoice.trigger_event(:invoice_generation)
        begin
          invoice.send_email if invoice.recurring_invoice.sent_by_email
        rescue Exception
          # silently ignore
        end
      end
    end

    invoices
  end

  def self.any_invoices_to_be_built?
    where(:enabled => true).where("starting_date <= ?", Date.current).each do |r_inv|
      if r_inv.next_occurrences.length > 0
        return true
      end
    end
    return false
  end

  private

  def valid_date_range
    return if starting_date.blank? || finishing_date.blank?

    if starting_date > finishing_date
      errors.add(:finishing_date, "The end date must be greater than the start date.")
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
