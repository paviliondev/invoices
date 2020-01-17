class PaymentReceiver < ActiveRecord::Base
  belongs_to :payment_provider
  has_many :common_payment_receivers, dependent: :destroy
  has_many :commons, through: :common_payment_receivers
  has_many :payments
  
  CURRENCIES ||= %w(usd gbp aud eur)
  
  def self.types
    Enum.new(
      bank: 1,
      credit_card: 2,
      service: 3
    )
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
