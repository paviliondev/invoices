class AddExternalIdToPaymentProvider < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_providers, :external_id, :string
  end
end
