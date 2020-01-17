require 'rails_helper'

RSpec.describe PaymentProvider, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
