class PaymentProviderSerializer < ActiveModel::Serializer
  attributes :id, :label, :provider_type, :connected
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
