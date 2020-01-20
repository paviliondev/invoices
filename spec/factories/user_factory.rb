FactoryBot.define do
  factory :user do
    name { 'Test User' }
    email { 'testuser@example.org' }
    password { 'testuser' }
    password_digest { "$2a$10$Ane3qzvv9wzinCQ.GjD4zuioQ5RNJAfq6wj1z5NBAwmuJkHD/KeOK" } # testuser
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  avatar_url      :string
#  email           :string(255)
#  groups          :string
#  name            :string(255)
#  password_digest :string(255)
#  remember_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  customer_id     :bigint
#
# Indexes
#
#  index_users_on_customer_id  (customer_id)
#  index_users_on_email        (email) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
