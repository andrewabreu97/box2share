class SubscriptionsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit]
  before_action :check_current_subscription, only: [:new, :edit]
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

  def edit
    @monthly_paid_plans = PaidPlan.active.month.where.not(id: params[:id])
    @yearly_paid_plans = PaidPlan.active.year.where.not(id: params[:id])
  end

  def update
    workflow = ChangesStripeSubscriptionPlan.new(
        subscription_id: current_user.paid_subscription.id,
        user: current_user,
        new_plan_id: params[:new_plan_id])
    workflow.run
    if workflow.success
      redirect_to panel_plan_path, notice: "Tu subscripción ha sido cambiada correctamente."
    else
      redirect_to panel_plan_path, alert: "Ha ocurrido un error al cambiar tu suscripción."
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

  private

    def stripe_subscription_workflow
      workflow = CreatesSubscriptionViaStripe.new(
          user: current_user,
          plan: @selected_plan,
          token: StripeToken.new(**card_params))
      workflow.run
      workflow
    end

    def card_params
      params.permit(
          :credit_card_number, :expiration_month,
          :expiration_year, :cvc,
          :stripe_token).to_h.symbolize_keys
    end

    def set_selected_plan
      @selected_plan = Plan.find(params[:plan_id])
    end

    def check_current_subscription
      if current_user.current_subscription.free?
        flash[:alert] = "Debes estar suscrito a una suscripción para cambiarla."
        redirect_back(fallback_location: root_path)
      else
        flash[:alert] = t('messages.failure.already_subscribed')
        redirect_back(fallback_location: root_path)
      end
    end

end
