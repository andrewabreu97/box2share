class PlansController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :check_current_subscription, only: [:show]

  def show
    @paid_plan = Plan.find(params[:id])
  end

  def index
    @free_plan = FreePlan.first
    @monthly_paid_plans = PaidPlan.active.month.all
    @yearly_paid_plans = PaidPlan.active.year.all
  end

  private
    def check_current_subscription
      unless current_user.current_subscription.free?
        flash[:alert] = t('messages.actually_paid_subscription')
        redirect_back(fallback_location: root_path)
      end
    end

end
