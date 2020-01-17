json.extract! payment_provider, :id, :provider, :active, :fee_type, :created_at, :updated_at
json.url payment_provider_url(payment_provider, format: :json)
