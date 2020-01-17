class AddApiKeyToPaymentProviders < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_providers, :api_key, :string
  end
end
