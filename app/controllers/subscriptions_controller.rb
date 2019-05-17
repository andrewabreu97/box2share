class SubscriptionsController < ApplicationController

  def destroy
    puts "params: #{params[:id]}"
    workflow = CancelsStripeSubscription.new(
        subscription_id: params[:id],
        user: current_user)
    workflow.run
    if workflow.success
      redirect_to panel_plan_path, notice: "Su suscripción ha sido cancelada con éxito."
    else
      redirect_to panel_plan_path, alert: "Ha ocurrido un problema al cancelar su suscripción."
    end
  end

end
