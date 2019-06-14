class Admin::PanelController < Admin::ApplicationController

  layout 'panel'

  def service_statistics
    @income = Payment.sum(:price_cents)
  end

end
