require 'rails_helper'

RSpec.describe "payment_receivers/index", type: :view do
  before(:each) do
    assign(:payment_receivers, [
      PaymentReceiver.create!(
        :payment_provider => nil,
        :payment_type => 2,
        :instructions => "Instructions",
        :currency => "Currency"
      ),
      PaymentReceiver.create!(
        :payment_provider => nil,
        :payment_type => 2,
        :instructions => "Instructions",
        :currency => "Currency"
      )
    ])
  end

  it "renders a list of payment_receivers" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Instructions".to_s, :count => 2
    assert_select "tr>td", :text => "Currency".to_s, :count => 2
  end
end
