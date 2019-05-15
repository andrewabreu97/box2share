class PlansController < ApplicationController
  def index
    @free_plan = FreePlan.first
    @monthly_paid_plans = PaidPlan.active.month.all
    @yearly_paid_plans = PaidPlan.active.year.all
  end
end
