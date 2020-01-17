class ItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :quantity, :unitary_cost, :discount, :tax_ids
  belongs_to :common
  has_many :taxes, links: {self: true, related: true}
  link(:self) { api_v1_item_path(object.id) }
  link(:taxes){ api_v1_item_taxes_path(item_id: object.id) }

  def tax_ids
     object.taxes.map {|t| t.id}
  end

end

# == Schema Information
#
# Table name: items
#
#  id           :bigint           not null, primary key
#  deleted_at   :datetime
#  description  :string(20000)
#  discount     :decimal(53, 2)   default(0.0), not null
#  quantity     :decimal(53, 15)  default(1.0), not null
#  unitary_cost :decimal(53, 15)  default(0.0), not null
#  common_id    :integer
#  product_id   :integer
#
# Indexes
#
#  common_id_idx              (common_id)
#  desc_idx                   (description)
#  index_items_on_deleted_at  (deleted_at)
#  item_product_id_idx        (product_id)
#
