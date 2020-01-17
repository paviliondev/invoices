class ChangePaymentProviderTypeToProvider < ActiveRecord::Migration[5.2]
  def change
    rename_column :payment_providers, :type, :provider
  end
end
