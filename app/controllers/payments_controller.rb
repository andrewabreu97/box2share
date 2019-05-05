class PaymentsController < ApplicationController

  def show
    @reference = params[:id]
    @payment = Payment.find_by(reference: @reference)
  end

  def create
    workflow = stripe_subscription_workflow
    if workflow.success
      redirect_to workflow.redirect_on_success_url
    else
      redirect_to subscription_cart_path
    end

  end

  private def stripe_subscription_workflow
    workflow = CreatesSubscriptionViaStripe.new(
        user: current_user,
        expected_subscription_id: params[:subscription_ids].first,
        token: StripeToken.new(**card_params))
    workflow.run
    workflow
  end

end
