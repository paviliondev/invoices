require 'rails_helper'

RSpec.describe RecurringInvoice, :type => :model do
  # WARNING: In these tests today is Wed, 01 Jun 2016!!!

  before do
    Timecop.freeze Date.new(2016, 6, 1)
    Celluloid.shutdown
    Celluloid.boot
  end

  after do
    Timecop.return
  end

  def build_recurring_invoice(**kwargs)
    kwargs[:starting_date] = Date.current() unless kwargs.has_key? :starting_date
    kwargs[:period_type] = 'month' unless kwargs.has_key? :period_type
    kwargs[:period] = 1 unless kwargs.has_key? :period
    kwargs[:series] = Series.new(value: "A") unless kwargs.has_key? :series

    customer = FactoryBot.create(:ncustomer)
    recurring_invoice = RecurringInvoice.new(
        name: customer.name, identification: customer.identification,
        customer:customer, **kwargs)
    recurring_invoice.set_amounts
    recurring_invoice
  end

  it "is active by default" do
    r = build_recurring_invoice()
    expect(r.enabled).to be true
  end

  it "is not valid, if active, without a start date" do
    r = build_recurring_invoice(starting_date: nil)
    expect(r).not_to be_valid
  end

  it "is not valid with a bad end date" do
    r = build_recurring_invoice(finishing_date: Date.new(2016, 5, 31))
    expect(r).not_to be_valid
    expect(r.errors.messages.has_key? :finishing_date).to be true
  end

  it "calculates next invoice date properly" do
    r = build_recurring_invoice()
    r.save

    expect(r.next_invoice_date).to eql r.starting_date

    RecurringInvoice.build_pending_invoices!
    r.reload

    expect(r.next_invoice_date).to eql Date.new(2016, 7, 1)
  end

  it "calculates next occurrences properly" do
    r = build_recurring_invoice(starting_date: Date.new(2016, 4, 1), period_type: "day", period: 15)
    expect(r.next_occurrences).to eq [
      Date.new(2016, 4, 1),
      Date.new(2016, 4, 16),
      Date.new(2016, 5, 1),
      Date.new(2016, 5, 16),
      Date.new(2016, 5, 31)
    ]
  end

  it "builds pending invoices properly" do
    r = build_recurring_invoice(starting_date: Date.new(2016, 4, 1))
    invoices = r.build_pending_invoices()
    expect(invoices.length).to eql 3
    expect(invoices[0].issue_date).to eq Date.new(2016, 4, 1)
    expect(invoices[1].issue_date).to eq Date.new(2016, 5, 1)
    expect(invoices[2].issue_date).to eq Date.new(2016, 6, 1)
  end

  it "generates invoices according to max_occurrences" do
    r = build_recurring_invoice(starting_date: Date.new(2016, 4, 1), max_occurrences: 2)
    invoices = r.build_pending_invoices()
    expect(invoices.length).to eql 2
    expect(invoices[0].issue_date).to eq Date.new(2016, 4, 1)
    expect(invoices[1].issue_date).to eq Date.new(2016, 5, 1)
  end

  it "generates invoices according to finishing_date" do
    r = build_recurring_invoice(starting_date: Date.new(2016, 3, 1), finishing_date: Date.new(2016, 5, 1))
    invoices = r.build_pending_invoices()
    expect(invoices.length).to eql 3
    expect(invoices[0].issue_date).to eq Date.new(2016, 3, 1)
    expect(invoices[1].issue_date).to eq Date.new(2016, 4, 1)
    expect(invoices[2].issue_date).to eq Date.new(2016, 5, 1)
  end

  it "class properly detects if there's any invoice to be generated" do
    expect(RecurringInvoice.any_invoices_to_be_built?).to be false
    build_recurring_invoice().save
    expect(RecurringInvoice.any_invoices_to_be_built?).to be true
  end

  it "class properly generates all pending invoices in order" do
    r1 = build_recurring_invoice(starting_date: Date.new(2016, 5, 1))
    r1.save
    r2 = build_recurring_invoice(starting_date: Date.new(2016, 5, 1))
    r2.save

    invoices = RecurringInvoice.build_pending_invoices!

    expect(invoices.length).to eql 4
    expect(invoices[0].issue_date).to eq Date.new(2016, 5, 1)
    expect(invoices[1].issue_date).to eq Date.new(2016, 5, 1)
    expect(invoices[2].issue_date).to eq Date.new(2016, 6, 1)
    expect(invoices[3].issue_date).to eq Date.new(2016, 6, 1)
  end

  it "is disabled when deleted and remains disabled when restored" do
    r = build_recurring_invoice()
    r.save
    expect(r.enabled).to be true

    expect(r.destroy).not_to be false
    expect(r.deleted?).to be true

    r.restore(recursive: true)
    expect(r.deleted?).to be false
    expect(r.enabled).to be false
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
