class PanelController < ApplicationController

  before_action :authenticate_user!

  layout 'panel'

  def dashboard
  end

  def plan
    @subscription = current_user.subscription
  end

end
