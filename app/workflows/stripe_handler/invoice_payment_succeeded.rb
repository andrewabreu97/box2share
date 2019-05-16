module StripeHandler

  class InvoicePaymentSucceeded

    attr_accessor :event, :success, :payment

    def initialize(event)
      @event = event
      @success = false
    end

    def run
      Subscription.transaction do
        return unless event
        current_subscription.inactive!
        new_subscription.active!
        new_subscription.update_end_date
        @payment = Payment.create!(
            user_id: user.id, price_cents: invoice.amount_paid,
            status: "succeeded", reference: Payment.generate_reference,
            payment_method: "stripe", response_id: invoice.charge,
            full_response: charge.to_json)
        payment.payment_line_items.create!(
            buyable: new_subscription, price_cents: invoice.amount_paid)
        @success = true
      end
    end

    def invoice
      @event.data.object
    end

    def current_subscription
       @current_subscription ||= user.current_subscription
    end

    def new_subscription
      @new_subscription ||= Subscription.find_by(remote_id: invoice.subscription)
    end

    def user
      @user ||= User.find_by(stripe_id: invoice.customer)
    end

    def charge
      @charge ||= Stripe::Charge.retrieve(invoice.charge)
    end

  end

end
