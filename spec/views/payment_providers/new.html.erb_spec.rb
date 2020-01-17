require 'rails_helper'

RSpec.describe "payment_providers/new", type: :view do
  before(:each) do
    assign(:payment_provider, PaymentProvider.new(
      :type => 1,
      :active => false,
      :fee_type => 1
    ))
  end

  it "renders new payment_provider form" do
    render

    assert_select "form[action=?][method=?]", payment_providers_path, "post" do

      assert_select "input[name=?]", "payment_provider[type]"

      assert_select "input[name=?]", "payment_provider[active]"

      assert_select "input[name=?]", "payment_provider[fee_type]"
    end
  end
end
