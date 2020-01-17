require 'rails_helper'

RSpec.describe "payment_providers/index", type: :view do
  before(:each) do
    assign(:payment_providers, [
      PaymentProvider.create!(
        :type => 2,
        :active => false,
        :fee_type => 3
      ),
      PaymentProvider.create!(
        :type => 2,
        :active => false,
        :fee_type => 3
      )
    ])
  end

  it "renders a list of payment_providers" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
