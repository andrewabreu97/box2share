class PaymentsController < ApplicationController
  before_action :authenticate_user!

  layout 'panel'

  def index
    @payments = current_user.payments
  end

  def show
    @reference = params[:id]
    @payment = Payment.find_by(reference: @reference)
  end

end
