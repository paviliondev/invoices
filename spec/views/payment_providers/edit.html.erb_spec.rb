require 'rails_helper'

RSpec.describe "payment_providers/edit", type: :view do
  before(:each) do
    @payment_provider = assign(:payment_provider, PaymentProvider.create!(
      :type => 1,
      :active => false,
      :fee_type => 1
    ))
  end

  it "renders the edit payment_provider form" do
    render

    assert_select "form[action=?][method=?]", payment_provider_path(@payment_provider), "post" do

      assert_select "input[name=?]", "payment_provider[type]"

      assert_select "input[name=?]", "payment_provider[active]"

      assert_select "input[name=?]", "payment_provider[fee_type]"
    end
  end
end
