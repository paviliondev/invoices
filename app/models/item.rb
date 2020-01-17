class Item < ActiveRecord::Base

  acts_as_paranoid
  belongs_to :common, optional: true
  has_and_belongs_to_many :taxes

  accepts_nested_attributes_for :taxes

  # Gets items for autocomplete, returning an id, a description and unitary cost
  # for the specified search term
  def Item.autocomplete_by_description(term)
    t = arel_table
    q = t
      .project(t[:id].maximum.as("id"), t[:description], t[:unitary_cost])
      .where(t[:description].matches("%#{term}%"))
      .group(t[:description], t[:unitary_cost])
      .order(t[:description])
    find_by_sql(q.to_sql)
  end

  def base_amount
    unitary_cost * quantity
  end

  def discount_amount
    base_amount * discount / 100.0
  end

  def net_amount
    if common
      (base_amount - discount_amount).round(common.currency_precision)
    else
      base_amount - discount_amount
    end
  end

  def to_s
    description? ? description : 'No description'
  end

  # Returns a hash where keys are the tax object
  # and values the tax calculated amount
  def taxes_hash
    taxes.each.inject({}) do |memo, tax|
      memo.merge({tax => net_amount * tax.value / 100.0})
    end
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, :quantity, :discount, :description, :unitary_cost)
      json.taxes  taxes.collect { |tax| tax.to_jbuilder.attributes!}
    end
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
