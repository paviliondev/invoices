FactoryBot.define do
  factory :token, class: Settings do
    var   { "api_token" }
    value { "123token" }
  end
end

# == Schema Information
#
# Table name: settings
#
#  id         :bigint           not null, primary key
#  thing_type :string(30)
#  value      :text
#  var        :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  thing_id   :integer
#
# Indexes
#
#  index_settings_on_thing_type_and_thing_id_and_var  (thing_type,thing_id,var) UNIQUE
#
