require 'rails_helper'

RSpec.describe "payment_providers/show", type: :view do
  before(:each) do
    @payment_provider = assign(:payment_provider, PaymentProvider.create!(
      :type => 2,
      :active => false,
      :fee_type => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/3/)
  end
end
