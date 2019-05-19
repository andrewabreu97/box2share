class PaymentMethodsController < ApplicationController

  def edit
  end

  def update
    @stripe_token = params[:stripe_token]
    if @stripe_token
      redirect_to panel_plan_path
    else
      redirect_to edit_payment_method_path
    end
  end

end
