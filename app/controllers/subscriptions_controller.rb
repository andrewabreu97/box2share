class SubscriptionsController < ApplicationController

  def new
    @paid_plan = Plan.find(params[:plan_id])
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

end
