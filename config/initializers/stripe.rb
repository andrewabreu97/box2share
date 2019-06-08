if Rails.env.production?
  Stripe.api_key = ENV['STRIPE_PRODUCTION_SECRET_KEY']
else
  Stripe.api_key = Rails.application.secrets.stripe_secret_key
end
#raise "Missing Stripe API Key" unless Stripe.api_key
STRIPE_JS_HOST = "https://js.stripe.com".freeze unless defined? STRIPE_JS_HOST
