class PaymentsController < ApplicationController
  before_action :authenticate_user!

  layout 'panel'

  def index
    @payments = current_user.payments
  end

end
