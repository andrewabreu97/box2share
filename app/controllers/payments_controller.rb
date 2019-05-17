class PaymentsController < ApplicationController

  before_action :set_selected_plan, only: [:create]

  def show
    @reference = params[:id]
    @payment = Payment.find_by(reference: @reference)
  end

  def create
    workflow = stripe_subscription_workflow
    if workflow.success
      redirect_to root_path
    else
      redirect_to plan_path(@selected_plan.id)
    end
  end

  private def stripe_subscription_workflow
    workflow = CreatesSubscriptionViaStripe.new(
        user: current_user,
        plan: @selected_plan,
        token: StripeToken.new(**card_params))
    workflow.run
    workflow
  end

  private def card_params
    params.permit(
        :credit_card_number, :expiration_month,
        :expiration_year, :cvc,
        :stripe_token).to_h.symbolize_keys
  end

  private def set_selected_plan
    @selected_plan = Plan.find(params[:plan_id])
  end

end
