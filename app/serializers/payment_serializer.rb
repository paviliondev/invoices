class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :notes, :date, :amount
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
