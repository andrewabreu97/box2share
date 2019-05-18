class SubscriptionsController < ApplicationController

  before_action :authenticate_user!, only: [:new]
  before_action :check_current_subscription, only: [:new]
  before_action :set_selected_plan, only: [:new, :create]

  def new
  end

  def create
    workflow = stripe_subscription_workflow
    if workflow.success
      redirect_to root_path, notice: t('messages.subscriptions.subscribed', name: @selected_plan.name)
    else
      redirect_to new_subscription_path(@selected_plan.id), alert: workflow.error_message
    end
  end

  def destroy
    workflow = CancelsStripeSubscription.new(
        subscription_id: params[:id],
        user: current_user)
    workflow.run
    if workflow.success
      redirect_to panel_plan_path, notice: t('messages.subscriptions.unsubscribed')
    else
      redirect_to panel_plan_path, alert: t('messages.failure.not_unsubscribed')
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

  private def check_current_subscription
    unless current_user.current_subscription.free?
      flash[:alert] = t('messages.actually_paid_subscription')
      redirect_back(fallback_location: root_path)
    end
  end

end
