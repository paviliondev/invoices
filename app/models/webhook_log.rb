class WebhookLog < ActiveRecord::Base
  def to_s
    "#{created_at} -- #{message}"
  end
end

# == Schema Information
#
# Table name: webhook_logs
#
#  id         :bigint           not null, primary key
#  event      :string(255)      not null
#  level      :string(255)      default("info"), not null
#  message    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_webhook_logs_on_event  (event)
#
