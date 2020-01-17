require 'rails_helper'

RSpec.describe "payment_receivers/new", type: :view do
  before(:each) do
    assign(:payment_receiver, PaymentReceiver.new(
      :payment_provider => nil,
      :payment_type => 1,
      :instructions => "MyString",
      :currency => "MyString"
    ))
  end

  it "renders new payment_receiver form" do
    render

    assert_select "form[action=?][method=?]", payment_receivers_path, "post" do

      assert_select "input[name=?]", "payment_receiver[payment_provider_id]"

      assert_select "input[name=?]", "payment_receiver[payment_type]"

      assert_select "input[name=?]", "payment_receiver[instructions]"

      assert_select "input[name=?]", "payment_receiver[currency]"
    end
  end
end
