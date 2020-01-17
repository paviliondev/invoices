class CommonPaymentReceiver < ActiveRecord::Base
  belongs_to :common
  belongs_to :payment_receiver
end

# == Schema Information
#
# Table name: common_payment_receivers
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  common_id           :bigint
#  payment_receiver_id :bigint
#
# Indexes
#
#  index_common_payment_receivers_on_common_id            (common_id)
#  index_common_payment_receivers_on_payment_receiver_id  (payment_receiver_id)
#
# Foreign Keys
#
#  fk_rails_...  (common_id => commons.id)
#  fk_rails_...  (payment_receiver_id => payment_receivers.id)
#
