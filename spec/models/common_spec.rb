require 'rails_helper'

RSpec.describe Common, :type => :model do

  def build_common(**kwargs)
    kwargs[:name] = "A Customer" unless kwargs.has_key? :name
    kwargs[:identification] = "123456789Z" unless kwargs.has_key? :identification
    kwargs[:series] = Series.new(value: "A") unless kwargs.has_key? :series

    common = Common.new(**kwargs, currency: "usd")
    common.set_amounts
    common
  end

  def new_common
    tax1 = Tax.new(value: 10)
    tax2 = Tax.new(value: 40)
    item1 = Item.new(quantity: 1, unitary_cost: 0.09, taxes: [tax1])
    item2 = Item.new(quantity: 1, unitary_cost: 0.09, taxes: [tax1, tax2])

    build_common(items: [item1, item2])
  end

  it "is not valid without a series" do
    c = build_common(series: nil)
    expect(c).not_to be_valid
    expect(c.errors.messages.has_key? :series).to be true
  end

  it "is not valid with at least a name or an identification" do
    c = build_common(name: nil, identification: nil)
    expect(c).not_to be_valid
  end

  it "is valid with at least a name" do
    c = build_common(identification: nil)
    expect(c).to be_valid
  end

  it "is valid with at least an identification" do
    c = build_common(name: nil)
    expect(c).to be_valid
  end

  it "is valid with valid emails" do
    c = build_common(email: "test@test.t10.de")
    expect(c).to be_valid
  end

  it "is not valid with bad e-mails" do
    c = build_common(email: "paquito")

    expect(c).not_to be_valid
    expect(c.errors.messages.length).to eq 1
    expect(c.errors.messages.has_key? :email).to be true

    c.email = "paquito@example"

    expect(c).not_to be_valid
    expect(c.errors.messages.length).to eq 1
    expect(c.errors.messages.has_key? :email).to be true
  end

  it "round total taxes according to currency" do
    c = new_common
    expect(c.tax_amount).to eq 0.06

    # BHD Bahrain Dinar has 3 decimals
    c.currency = "bhd"
    expect(c.tax_amount).to eq 0.054
  end

  it "has right totals after set_amounts" do
    c = new_common
    c.set_amounts
    expect(c.gross_amount).to eq 0.24
    expect(c.net_amount).to eq 0.18

    # BHD Bahrain Dinar has 3 decimals
    c.currency = "bhd"
    c.set_amounts
    expect(c.gross_amount).to eq 0.234
    expect(c.net_amount).to eq 0.18
  end

end

# == Schema Information
#
# Table name: commons
#
#  id                   :bigint           not null, primary key
#  contact_person       :string(100)
#  currency             :string(3)
#  days_to_due          :integer
#  deleted_at           :datetime
#  deleted_number       :integer
#  draft                :boolean          default(FALSE)
#  due_date             :date
#  email                :string(100)
#  enabled              :boolean          default(TRUE)
#  failed               :boolean          default(FALSE)
#  finishing_date       :date
#  gross_amount         :decimal(53, 15)  default(0.0)
#  identification       :string(50)
#  invoicing_address    :text
#  issue_date           :date
#  max_occurrences      :integer
#  meta_attributes      :text
#  must_occurrences     :integer
#  name                 :string(100)
#  net_amount           :decimal(53, 15)  default(0.0)
#  notes                :text
#  number               :integer
#  paid                 :boolean          default(FALSE)
#  paid_amount          :decimal(53, 15)  default(0.0)
#  period               :integer
#  period_type          :string(8)
#  sent_by_email        :boolean          default(FALSE)
#  shipping_address     :text
#  starting_date        :date
#  terms                :text
#  type                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  customer_id          :integer          not null
#  email_template_id    :integer
#  print_template_id    :integer
#  recurring_invoice_id :integer
#  series_id            :integer
#
# Indexes
#
#  cntct_idx                              (contact_person)
#  common_deleted_number_idx              (series_id,deleted_number)
#  common_recurring_invoice_id_common_id  (recurring_invoice_id)
#  common_type_idx                        (type)
#  common_unique_number_idx               (series_id,number) UNIQUE
#  cstid_idx                              (identification)
#  cstml_idx                              (email)
#  cstnm_idx                              (name)
#  customer_id_idx                        (customer_id)
#  index_commons_on_deleted_at            (deleted_at)
#  series_id_idx                          (series_id)
#  type_and_status_idx                    (type)
#
