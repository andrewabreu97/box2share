class PlansController < ApplicationController

  def show
    @paid_plan = Plan.find(params[:id])
  end

  def index
    @free_plan = FreePlan.first
    @monthly_paid_plans = PaidPlan.active.month.all
    @yearly_paid_plans = PaidPlan.active.year.all
  end

end
