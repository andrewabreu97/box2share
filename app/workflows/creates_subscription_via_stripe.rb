class CreatesSubscriptionViaStripe

  attr_accessor :user, :token, :plan, :success, :error_message

  def initialize(user:, plan:, token:)
    @user = user
    @plan = plan
    @token = token
    @success = false
  end

  def subscription
    @subscription ||= Subscription.create!(
        user: user, plan: plan,
        start_date: Time.zone.now.to_date,
        end_date: plan.end_date_from,
        status: :waiting, type: "PaidSubscription")
  end

  def run
    Payment.transaction do
      stripe_customer = StripeCustomer.new(user: user)
      return unless stripe_customer.valid?
      stripe_customer.source = token
      subscription.make_stripe_payment(stripe_customer)
      stripe_customer.add_subscription(subscription)
      @success = true
    end
  rescue Stripe::StripeError => e
    @error_message = I18n.t("stripe.errors.#{e.code}")
    Rollbar.error(e)
  end

  def redirect_on_success_url
    root_path
  end

end
