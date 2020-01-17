require "rails_helper"

RSpec.describe PaymentReceiversController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/payment_receivers").to route_to("payment_receivers#index")
    end

    it "routes to #new" do
      expect(:get => "/payment_receivers/new").to route_to("payment_receivers#new")
    end

    it "routes to #show" do
      expect(:get => "/payment_receivers/1").to route_to("payment_receivers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/payment_receivers/1/edit").to route_to("payment_receivers#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/payment_receivers").to route_to("payment_receivers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/payment_receivers/1").to route_to("payment_receivers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/payment_receivers/1").to route_to("payment_receivers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/payment_receivers/1").to route_to("payment_receivers#destroy", :id => "1")
    end
  end
end
