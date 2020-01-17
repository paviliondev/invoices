class AddLabelToPaymentReceivers < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_receivers, :label, :string
  end
end
