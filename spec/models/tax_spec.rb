require 'rails_helper'

RSpec.describe Tax, :type => :model do
  let(:klass) { described_class }

  describe "#validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_numericality_of(:value) }
  end

  it "must be active and not default by default" do
    tax = Tax.create!(name: 'tax_name', value: '12')
    expect(tax).to be_valid
    expect(tax.active).to be true
    expect(tax.default).to be false
  end

  it "can't be deleted if an item has the tax" do
    tax = Tax.create!(name: 'tax_name', value: '12')
    Item.create!(taxes: [tax])
    expect(tax.destroy).to be false
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
