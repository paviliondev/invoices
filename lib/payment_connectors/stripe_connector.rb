class StripeConnector
  def initialize(provider)
    if provider.api_key
      Stripe.api_key = provider.api_key
    else
      false
    end
  end
  
  def test
    Stripe::Account.list({limit: 1})
  end
end