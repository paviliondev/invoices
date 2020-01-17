require 'rails_helper'

RSpec.describe PaymentReceiver, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
