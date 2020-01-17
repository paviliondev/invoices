require 'rails_helper'

RSpec.describe Item, :type => :model do

  it "rounds the net_amount according to currency" do
    c = FactoryBot.create(:common)
    item = Item.new(quantity: 1, discount: 5, unitary_cost: 0.08, common: c)
    expect(item.discount_amount).to eq 0.004
    expect(item.net_amount).to eq 0.08

    # BHD Bahrain Dinar has 3 decimals
    c.currency = "bhd"
    expect(item.net_amount).to eq 0.076
  end

  it "taxes_hash has net_amount * tax.value / 100.0" do
    c = FactoryBot.create(:common)
    tax1 = Tax.new(value: 10)
    tax2 = Tax.new(value: 25)
    item = Item.new(
      quantity:1,
      unitary_cost: 1,
      discount: 0.5,
      taxes: [tax1, tax2],
      common: c
    )
    expect(item.taxes_hash).to eq ({tax1 => 0.1, tax2 => 0.25})
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
