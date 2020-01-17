class CreatePaymentReceivers < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_receivers do |t|
      t.references :payment_provider, foreign_key: true
      t.integer :payment_type
      t.string :instructions
      t.string :currency

      t.timestamps
    end
  end
end
