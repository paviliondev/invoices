class CustomerSerializer < ActiveModel::Serializer
  attributes :name, :identification, :email, :contact_person, :invoicing_address, :shipping_address
end

# == Schema Information
#
# Table name: customers
#
#  id                :bigint           not null, primary key
#  active            :boolean          default(TRUE)
#  contact_person    :string(100)
#  deleted_at        :datetime
#  email             :string(100)
#  group             :string
#  identification    :string(50)
#  invoicing_address :text
#  meta_attributes   :text
#  name              :string(100)
#  name_slug         :string(100)
#  shipping_address  :text
#
# Indexes
#
#  cstm_slug_idx                  (name_slug) UNIQUE
#  index_customers_on_deleted_at  (deleted_at)
#
