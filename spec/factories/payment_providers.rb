FactoryBot.define do
  factory :payment_provider do
    type { 1 }
    active { false }
    fee_type { 1 }
  end
end

# == Schema Information
#
# Table name: payment_providers
#
#  id            :bigint           not null, primary key
#  api_key       :string
#  connected     :boolean
#  label         :string
#  provider_type :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  external_id   :string
#
