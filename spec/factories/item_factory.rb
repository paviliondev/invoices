FactoryBot.define do

  factory :item do
    description { "Invoicing App Development" }
    unitary_cost { 10000 }

    after :build do |item|
      item.taxes << (Tax.find_by(id: 1) || create(:vat))
      item.taxes << (Tax.find_by(id: 2) || create(:retention))
    end

    # WARNING: DON'T USE FOR TESTS!!!
    trait :invoice_item_demo do
      unitary_cost { Faker::Commerce.price * 1000 }
      description { "#{Faker::App.unique.name} App Development" }
    end

    # WARNING: DON'T USE FOR TESTS!!!
    trait :recurring_invoice_item_demo do
      description { "Website Maintenance" }
      unitary_cost { Faker::Commerce.price * 10 }
    end
  end

end

# == Schema Information
#
# Table name: items
#
#  id           :bigint           not null, primary key
#  deleted_at   :datetime
#  description  :string(20000)
#  discount     :decimal(53, 2)   default(0.0), not null
#  quantity     :decimal(53, 15)  default(1.0), not null
#  unitary_cost :decimal(53, 15)  default(0.0), not null
#  common_id    :integer
#  product_id   :integer
#
# Indexes
#
#  common_id_idx              (common_id)
#  desc_idx                   (description)
#  index_items_on_deleted_at  (deleted_at)
#  item_product_id_idx        (product_id)
#
