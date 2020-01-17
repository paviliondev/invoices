class AddPaymentReceiverToPayments < ActiveRecord::Migration[5.2]
  def change
    add_reference :payments, :payment_receiver, foreign_key: true
  end
end
