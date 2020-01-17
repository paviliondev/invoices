class AddStatusToPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :status, :integer, default: 1
  end
end
