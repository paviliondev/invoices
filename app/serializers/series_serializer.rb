class SeriesSerializer < ActiveModel::Serializer
  attributes :name, :value, :enabled, :first_number
end

# == Schema Information
#
# Table name: series
#
#  id           :bigint           not null, primary key
#  default      :boolean          default(FALSE)
#  deleted_at   :datetime
#  enabled      :boolean          default(TRUE)
#  first_number :integer          default(1)
#  name         :string(255)
#  value        :string(255)
#
# Indexes
#
#  index_series_on_deleted_at  (deleted_at)
#
