Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe][:secret_key]
#raise "Missing Stripe API Key" unless Stripe.api_key
STRIPE_JS_HOST = "https://js.stripe.com".freeze unless defined? STRIPE_JS_HOST
