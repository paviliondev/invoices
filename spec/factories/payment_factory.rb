FactoryBot.define do
  factory :payment, class: Payment do
    date { Date.current }
    amount { 10 }
  end

  factory :payment_random, class: Payment do
    date { Date.current }
    amount { rand(1..10) }
    notes do
      pay_method = ['visa', 'mastercard', 'american express'].sample
      "Paid by #{pay_method}."
    end
  end
end

# == Schema Information
#
# Table name: payments
#
#  id                  :bigint           not null, primary key
#  amount              :decimal(53, 15)
#  date                :date
#  deleted_at          :datetime
#  notes               :text
#  status              :integer          default(1)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  invoice_id          :integer          not null
#  payment_receiver_id :bigint
#
# Indexes
#
#  index_payments_on_deleted_at           (deleted_at)
#  index_payments_on_payment_receiver_id  (payment_receiver_id)
#  invoice_id_idx                         (invoice_id)
#
# Foreign Keys
#
#  fk_rails_...  (payment_receiver_id => payment_receivers.id)
#
