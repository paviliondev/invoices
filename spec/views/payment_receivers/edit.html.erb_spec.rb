require 'rails_helper'

RSpec.describe "payment_receivers/edit", type: :view do
  before(:each) do
    @payment_receiver = assign(:payment_receiver, PaymentReceiver.create!(
      :payment_provider => nil,
      :payment_type => 1,
      :instructions => "MyString",
      :currency => "MyString"
    ))
  end

  it "renders the edit payment_receiver form" do
    render

    assert_select "form[action=?][method=?]", payment_receiver_path(@payment_receiver), "post" do

      assert_select "input[name=?]", "payment_receiver[payment_provider_id]"

      assert_select "input[name=?]", "payment_receiver[payment_type]"

      assert_select "input[name=?]", "payment_receiver[instructions]"

      assert_select "input[name=?]", "payment_receiver[currency]"
    end
  end
end
