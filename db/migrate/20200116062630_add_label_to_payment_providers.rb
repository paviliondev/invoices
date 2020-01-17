class AddLabelToPaymentProviders < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_providers, :label, :string
  end
end
