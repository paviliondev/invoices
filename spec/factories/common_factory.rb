FactoryBot.define do
  factory :common do
    name { "Test Customer" }
    identification { "12345" }
    email { "customer@example.com" }
    currency { "usd" }

    after :build do |common|
      common.series = common.series || Series.find_by(default: true) || create(:series, :default)

      if common.customer
        common.name = common.customer.name
        common.identification = common.customer.identification
        common.email = common.customer.email
        common.contact_person = common.customer.contact_person
        common.invoicing_address = common.customer.invoicing_address
      else
        common.customer = Customer.find_by(identification: common.identification) || create(
          :customer,
          name: common.name,
          identification: common.identification,
          email: common.email
        )
      end

      common.items << build(:item) if common.items.empty?
      common.set_amounts
    end

    factory :invoice, class: Invoice do
      issue_date { Date.current }

      trait :paid do
        after :build do |invoice|
          invoice.set_paid
        end
      end

      factory :due_invoice do
        transient do
          first_day { Date.current - 30 }
        end
        sequence(:issue_date, 0) { |n| first_day + n }
        due_date { issue_date + 1 }

        association :customer, factory: :demo_customer, strategy: :build
      end

      # WARNING: DON'T USE FOR TESTS!!!
      factory :demo_invoice do
        transient do
          first_day { Date.current }
        end
        sequence(:issue_date, 0) { |n| first_day + n }
        due_date { issue_date + 30 }

        association :customer, factory: :demo_customer, strategy: :build
        items { build_list(:item, 1, :invoice_item_demo) }

        after :build do |invoice|
          if Faker::Boolean.boolean(true_ratio: 0.65)
            invoice.set_paid
          end
        end
      end
    end

    factory :recurring_invoice, class: RecurringInvoice do
      starting_date { Date.current }
      period_type { "month" }
      period { 1 }
      days_to_due { 30 }
      currency { "usd" }

      # WARNING: DON'T USE FOR TESTS!!!
      factory :demo_recurring_invoice do
        association :customer, factory: :demo_customer, strategy: :build
        items { build_list(:item, 1, :recurring_invoice_item_demo) }
      end
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
