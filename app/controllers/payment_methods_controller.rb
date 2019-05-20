class PaymentMethodsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_edit_payment_method, only: [:edit]

  def edit
  end

  def update
    workflow = ChangesPaymentMethod.new(
      user: current_user,
      token: StripeToken.new(**card_params))
    workflow.run
    if workflow.success
      redirect_to panel_plan_path, notice: t('.success.update_payment_method')
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

    def check_edit_payment_method
      if current_user.current_subscription.free?
        flash[:alert] = t('failure.no_paid_subscription')
        redirect_back(fallback_location: root_path)
      end
    end

end
