class PaymentMethodsController < ApplicationController

  def edit
  end

  def update
    workflow = ChangesPaymentMethod.new(user: current_user, token: StripeToken.new(**card_params))
    workflow.run
    if workflow.success
      redirect_to panel_plan_path, notice: "Tu método de pago ha sido actualizado correctamente."
    else
      redirect_to edit_payment_method_path, alert: workflow.error_message
    end
  end

  private def card_params
    params.permit(
        :credit_card_number, :expiration_month,
        :expiration_year, :cvc,
        :stripe_token).to_h.symbolize_keys
  end

end
