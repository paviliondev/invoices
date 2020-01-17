require 'rails_helper'

RSpec.describe Invoice, :type => :model do

  def build_invoice(**kwargs)
    kwargs[:issue_date] = Date.current() unless kwargs.has_key? :issue_date
    kwargs[:series] = Series.new(value: "A") unless kwargs.has_key? :series


    customer = FactoryBot.create(:ncustomer)
    invoice = Invoice.new(name: customer.name, identification: customer.identification,
                          customer: customer, **kwargs)
    invoice.set_amounts
    invoice
  end

  #
  # Invoice Number
  #

  it "has no invoice number if it's a draft" do
    invoice = build_invoice(draft: true, number: 1)
    invoice.save

    expect(invoice.number).to be nil
  end

  it "gets an invoice number after saving if it's not a draft" do
    series = Series.new(value: "A", first_number: 5)
    invoice1 = build_invoice(series: series)
    invoice1.save
    invoice2 = build_invoice(series: series)
    invoice2.save

    expect(invoice1.number).to eq 5
    expect(invoice2.number).to eq 6
  end

  it "may have the same number as another invoice from a different series" do
    invoice1 = build_invoice(series: Series.new(value: "A"))
    invoice1.save

    invoice2 = build_invoice(series: Series.new(value: "B"))
    invoice2.save

    expect(invoice1.number).to eq 1
    expect(invoice2.number).to eq invoice1.number
  end

  it "can't have the same number as another invoice from the same series" do
    invoice1 = build_invoice()
    expect(invoice1.save).to be true

    invoice2 = build_invoice(series: invoice1.series, number: invoice1.number)
    expect(invoice2.save).to be false
  end

  it "retains the same number after saving" do
    invoice = build_invoice(number: 2)
    invoice.save

    expect(invoice.number).to eq 2
  end

  it "loses the number on deletion" do
    invoice = build_invoice()
    invoice.save

    expect(invoice.number).to eq 1

    invoice.destroy
    invoice.reload

    expect(invoice.deleted?).to be true
    expect(invoice.number).to be_nil
  end

  it "can coexist, when deleted, with other deleted invoices in the same series" do
    invoice1 = build_invoice()
    expect(invoice1.save).to be true

    invoice2 = build_invoice(series: invoice1.series)
    expect(invoice2.save).to be true

    expect(invoice1.destroy).not_to be false
    expect(invoice2.destroy).not_to be false
  end

  it "when deleted stores number_was" do
    invoice = build_invoice()
    invoice.save
    number = invoice.number
    invoice.destroy
    invoice.reload
    expect(invoice.deleted_number).to eq number
  end

  it "is restored as draft" do
    invoice = build_invoice()
    invoice.save

    expect(invoice.destroy).not_to be false
    expect(invoice.deleted?).to be true

    invoice.restore(recursive: true)
    expect(invoice.deleted?).to be false
    expect(invoice.draft).to be true
  end

  #
  # Status
  #

  it "returns the right status: draft" do
    invoice = build_invoice(draft: true)
    expect(invoice.get_status()).to eq :draft
  end

  it "returns the right status: failed" do
    invoice = build_invoice(failed: true)
    expect(invoice.get_status()).to eq :failed
  end

  it "returns the right status: pending" do
    invoice = build_invoice(items: [Item.new(quantity: 1, unitary_cost: 10)], due_date: Date.current() + 1)
    expect(invoice.get_status()).to eq :pending
  end

  it "returns the right status: past due" do
    invoice = build_invoice(items: [Item.new(quantity: 1, unitary_cost: 10)],
                            due_date: Date.current())
    expect(invoice.get_status()).to eq :past_due
  end

  it "returns the right status: paid" do
    invoice = build_invoice(items: [Item.new(quantity: 1, unitary_cost: 10)],
                            payments: [Payment.new(amount: 10, date: Date.current)])
    invoice.check_paid
    expect(invoice.get_status()).to eq :paid
  end

  #
  # Payments
  #

  it "computes payments right" do
    # No payment received
    invoice = build_invoice(items: [Item.new(quantity: 5, unitary_cost: 10)])
    # invoice.save

    invoice.check_paid
    expect(invoice.paid).to be false
    expect(invoice.paid_amount).to eq 0
    expect(invoice.unpaid_amount).to eq 50

    # Partially paid
    invoice.payments << Payment.new(amount: 40, date: Date.current)

    invoice.check_paid
    expect(invoice.paid).to be false
    expect(invoice.paid_amount).to eq 40
    expect(invoice.unpaid_amount).to eq 10

    # Fully paid
    invoice.payments << Payment.new(amount: 10, date: Date.current)

    invoice.check_paid
    expect(invoice.paid).to be true
    expect(invoice.paid_amount).to eq 50
    expect(invoice.unpaid_amount).to eq 0
  end

  it "sets paid right" do
    # A draft invoice can't be paid
    invoice = build_invoice(items: [Item.new(quantity: 5, unitary_cost: 10)], draft: true)

    expect(invoice.set_paid).to be false
    expect(invoice.paid).to be false

    # Remove draft switch and add a Payment; should be paid now
    invoice.payments << Payment.new(amount: 10, date: Date.current)
    invoice.check_paid
    invoice.draft = false

    expect(invoice.set_paid).to be true
    expect(invoice.paid).to be true
    expect(invoice.paid_amount).to eq 50
    expect(invoice.payments.length).to eq 2
    expect(invoice.payments[1].amount).to eq 40

    # A paid invoice should not be affected
    expect(invoice.set_paid).to be false
    expect(invoice.paid).to be true
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
