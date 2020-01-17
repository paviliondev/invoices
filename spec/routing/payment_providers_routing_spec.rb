require "rails_helper"

RSpec.describe PaymentProvidersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/payment_providers").to route_to("payment_providers#index")
    end

    it "routes to #new" do
      expect(:get => "/payment_providers/new").to route_to("payment_providers#new")
    end

    it "routes to #show" do
      expect(:get => "/payment_providers/1").to route_to("payment_providers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/payment_providers/1/edit").to route_to("payment_providers#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/payment_providers").to route_to("payment_providers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/payment_providers/1").to route_to("payment_providers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/payment_providers/1").to route_to("payment_providers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/payment_providers/1").to route_to("payment_providers#destroy", :id => "1")
    end
  end
end
