class ChangesPaymentMethod

  attr_accessor :user, :token, :success, :error_message

  def initialize(user:, token:)
    @user = user
    @token = token
    @success = false
  end

  def run
    begin
      stripe_customer = StripeCustomer.new(user: user)
      return unless stripe_customer.valid?
      stripe_customer.source = token
      stripe_customer.save_non_sensible_card_info
      @success = true
    end
  rescue Stripe::StripeError => e
    @error_message = I18n.t("stripe.errors.#{e.code}")
    Rollbar.error(e)
  end

  def redirect_on_success_url
    panel_plan_path
  end

end
