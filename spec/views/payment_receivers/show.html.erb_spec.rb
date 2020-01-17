require 'rails_helper'

RSpec.describe "payment_receivers/show", type: :view do
  before(:each) do
    @payment_receiver = assign(:payment_receiver, PaymentReceiver.create!(
      :payment_provider => nil,
      :payment_type => 2,
      :instructions => "Instructions",
      :currency => "Currency"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Instructions/)
    expect(rendered).to match(/Currency/)
  end
end
