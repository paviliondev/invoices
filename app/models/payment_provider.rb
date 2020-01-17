class PaymentProvider < ActiveRecord::Base
  validate :setup
  
  has_many :payment_receivers, dependent: :destroy
    
  def self.types
    ::Enum.new(
      transferwise: 1,
      stripe: 2,
      paypal: 3
    )
  end
  
  def setup
    if connected
      result = connector.test
          
      if !result || result.respond_to?(:error)
        errors.add(:connection, result.error || "Failed to connect to provider")
        return if new_record?
      end
      
      self.external_id = result
      self.save(validate: false)
    end
  end
  
  def connector
    @connector ||= "#{PaymentProvider.types[provider_type].capitalize}Connector".constantize.new(self)
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
