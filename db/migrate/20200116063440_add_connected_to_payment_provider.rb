class AddConnectedToPaymentProvider < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_providers, :connected, :boolean
  end
end
