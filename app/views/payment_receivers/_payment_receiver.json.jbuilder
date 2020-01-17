json.extract! payment_receiver, :id, :payment_provider_id, :payment_type, :instructions, :currency, :created_at, :updated_at
json.url payment_receiver_url(payment_receiver, format: :json)
