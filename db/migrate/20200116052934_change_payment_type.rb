class ChangePaymentType < ActiveRecord::Migration[5.2]
  def change
    rename_column :payment_receivers, :payment_type, :receiver_type
  end
end
