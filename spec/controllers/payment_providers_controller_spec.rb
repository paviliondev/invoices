require 'rails_helper'

RSpec.describe PaymentProvidersController, type: :controller do
  let(:valid_attributes) {
    { provider: 1, api_key: 'af23nonalsdkfnaawo3fnlasdf', active: true }
  }

  let(:invalid_attributes) {
    { provider: 3, api_key: { key: 'val' }, active: 'true' }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PaymentProvidersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      PaymentProvider.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      payment_provider = PaymentProvider.create! valid_attributes
      get :show, params: {id: payment_provider.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      payment_provider = PaymentProvider.create! valid_attributes
      get :edit, params: {id: payment_provider.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new PaymentProvider" do
        expect {
          post :create, params: {payment_provider: valid_attributes}, session: valid_session
        }.to change(PaymentProvider, :count).by(1)
      end

      it "redirects to the created payment_provider" do
        post :create, params: {payment_provider: valid_attributes}, session: valid_session
        expect(response).to redirect_to(PaymentProvider.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {payment_provider: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested payment_provider" do
        payment_provider = PaymentProvider.create! valid_attributes
        put :update, params: {id: payment_provider.to_param, payment_provider: new_attributes}, session: valid_session
        payment_provider.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the payment_provider" do
        payment_provider = PaymentProvider.create! valid_attributes
        put :update, params: {id: payment_provider.to_param, payment_provider: valid_attributes}, session: valid_session
        expect(response).to redirect_to(payment_provider)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        payment_provider = PaymentProvider.create! valid_attributes
        put :update, params: {id: payment_provider.to_param, payment_provider: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested payment_provider" do
      payment_provider = PaymentProvider.create! valid_attributes
      expect {
        delete :destroy, params: {id: payment_provider.to_param}, session: valid_session
      }.to change(PaymentProvider, :count).by(-1)
    end

    it "redirects to the payment_providers list" do
      payment_provider = PaymentProvider.create! valid_attributes
      delete :destroy, params: {id: payment_provider.to_param}, session: valid_session
      expect(response).to redirect_to(payment_providers_url)
    end
  end

end
