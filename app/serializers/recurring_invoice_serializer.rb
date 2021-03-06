class RecurringInvoiceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :series_id, :currency,
    :customer_id, :identification, :name,
    :email, :contact_person, :invoicing_address,
    :shipping_address, :terms, :notes,
    :enabled, :days_to_due, :starting_date,
    :finishing_date, :period, :period_type,
    :max_occurrences, :sent_by_email,
    :net_amount, :gross_amount, :taxes,
    :tag_list, :meta

  meta do |serializer|
    if object.meta_attributes
      ActiveSupport::JSON.decode(object.meta_attributes)
    end
  end

  belongs_to :customer, url: true
  has_many :items

  link(:self) { api_v1_recurring_invoice_path(object.id) }
  link(:customer){ api_v1_customer_path(object.customer_id) }
  link(:items){ api_v1_recurring_invoice_items_path(recurring_invoice_id: object.id) }

  def initialize(object, options={})
    super
    object.set_amounts
  end

  def items
    customized_items = []
    object.items.each do |item|
      custom_item = {"attributes": item.attributes}
      customized_items.push(custom_item)
    end
    return customized_items
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
