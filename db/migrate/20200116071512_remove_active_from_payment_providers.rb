class RemoveActiveFromPaymentProviders < ActiveRecord::Migration[5.2]
  def change
    remove_column :payment_providers, :active, :boolean
  end
end
