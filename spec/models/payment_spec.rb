require 'rails_helper'

RSpec.describe Payment, :type => :model do

  describe "#validations" do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount) }
  end

  it "valid payment" do
    expect(Payment.new(amount: 10, date: Date.current, invoice: Invoice.new)).to be_valid
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
