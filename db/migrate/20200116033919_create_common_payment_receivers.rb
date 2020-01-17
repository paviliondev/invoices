class CreateCommonPaymentReceivers < ActiveRecord::Migration[5.2]
  def change
    create_table :common_payment_receivers do |t|
      t.references :common, foreign_key: true
      t.references :payment_receiver, foreign_key: true

      t.timestamps
    end
  end
end
