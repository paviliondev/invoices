require 'rails_helper'

RSpec.describe "PaymentReceivers", type: :request do
  describe "GET /payment_receivers" do
    it "works! (now write some real specs)" do
      get payment_receivers_path
      expect(response).to have_http_status(200)
    end
  end
end
