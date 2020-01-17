class Payment < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :invoice
  belongs_to :payment_receiver, optional: true
  has_one :customer, through: :invoice

  validates :date, presence: true
  validates :amount, presence: true, numericality: true
  
  before_save do
    self.amount = self.amount.round self.invoice.currency_precision
  end

  after_save do
  	invoice.save
  end

  after_destroy do
    invoice.save
  end
  
  def complete?
    status == Payment.statuses[:complete]
  end
  
  def self.statuses
    ::Enum.new(
      initial: 1,
      pending: 2,
      complete: 3
    )
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, :date, :amount, :notes)
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
