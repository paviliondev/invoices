FactoryBot.define do
  factory :payment_receiver do
    payment_provider { nil }
    payment_type { 1 }
    instructions { "MyString" }
    currency { "MyString" }
  end
end

# == Schema Information
#
# Table name: payment_receivers
#
#  id                  :bigint           not null, primary key
#  currency            :string
#  instructions        :string
#  label               :string
#  receiver_type       :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  payment_provider_id :bigint
#
# Indexes
#
#  index_payment_receivers_on_payment_provider_id  (payment_provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (payment_provider_id => payment_providers.id)
#
