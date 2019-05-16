class SubscriptionCartsController < ApplicationController
  def show
    @paid_plan = Plan.find(params[:plan_id])
    #@cart = SubscriptionCart.new(current_user)
  end

  def update

    redirect_to subscription_cart_path
    # workflow = AddsPlanToCart.new(user: current_user, plan: plan)
    # workflow.run
    # if workflow.result
    #   redirect_to subscription_cart_path
    # else
    #   redirect_to plans_path
    # end
  end



end
