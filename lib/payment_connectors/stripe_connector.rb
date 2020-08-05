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
  
  def checkout_url(params)
    line_items = params[:items].map do |item|
      {
        name: item.description,
        amount: item.unitary_cost,
        currency: 'USD',
        quantity: item.quantity
      }
    end
    
    session = Stripe::Checkout::Session.create(
      customer_email: params[:email],
      payment_method_types: ['card'],
      line_items: line_items,
      success_url: 'https://example.com/success',
      cancel_url: 'https://example.com/cancel',
    )
  end
end