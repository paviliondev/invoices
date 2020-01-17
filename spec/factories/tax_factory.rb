FactoryBot.define do
  factory :vat, class: Tax do
    id { 1 }
    value { 21 }
    name { "VAT" }
  end

  factory :retention, class: Tax do
    id { 2 }
    value { -15 }
    name { "RETENTION" }
  end
end

# == Schema Information
#
# Table name: taxes
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  default    :boolean          default(FALSE)
#  deleted_at :datetime
#  name       :string(50)
#  value      :decimal(53, 2)
#
# Indexes
#
#  index_taxes_on_deleted_at  (deleted_at)
#
