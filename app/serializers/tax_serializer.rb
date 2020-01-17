class TaxSerializer < ActiveModel::Serializer
  attributes :id, :name, :value, :active, :default
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
