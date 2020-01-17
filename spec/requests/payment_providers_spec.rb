require 'rails_helper'

RSpec.describe "PaymentProviders", type: :request do
  describe "GET /payment_providers" do
    it "works! (now write some real specs)" do
      get payment_providers_path
      expect(response).to have_http_status(200)
    end
  end
end
