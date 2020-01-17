require 'rails_helper'

RSpec.describe SingleSignOnRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: single_sign_on_records
#
#  id                :bigint           not null, primary key
#  external_email    :string
#  external_name     :string
#  external_username :string
#  last_payload      :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  external_id       :string
#  user_id           :bigint
#
# Indexes
#
#  index_single_sign_on_records_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
