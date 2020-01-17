class CreatePaymentProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_providers do |t|
      t.integer :type
      t.boolean :active
      t.integer :fee_type

      t.timestamps
    end
  end
end
