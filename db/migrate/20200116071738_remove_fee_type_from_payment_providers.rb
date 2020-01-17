class RemoveFeeTypeFromPaymentProviders < ActiveRecord::Migration[5.2]
  def change
    remove_column :payment_providers, :fee_type, :integer
  end
end
