class PaymentMethodsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_current_subscription

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

  private
    def card_params
      params.permit(
          :credit_card_number, :expiration_month,
          :expiration_year, :cvc,
          :stripe_token).to_h.symbolize_keys
    end

    def check_current_subscription
      if current_user.current_subscription.free?
        flash[:alert] = "Debes estar suscrito a un plan de pago para cambiar tu método de pago."
        redirect_back(fallback_location: root_path)
      end
    end

end
