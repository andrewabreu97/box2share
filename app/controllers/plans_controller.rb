class PlansController < ApplicationController
  def index
    @plans = Plan.active.month.all
  end
end
