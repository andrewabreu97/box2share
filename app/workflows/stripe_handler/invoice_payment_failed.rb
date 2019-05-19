module StripeHandler

  class InvoicePaymentFailed

    attr_accessor :event, :success, :payment

    def initialize(event)
      @event = event
      @success = false
    end

    def run
      Subscription.transaction do
        return unless event
        if invoice.attempt_count >= 1 && invoice.next_payment_attempt
          # notify user first attempt to pay invoice
        else
          # final warning to user
        end
        unless current_subscription.free?
          subscription.inactive!
          user.free_subscription.active!
        else
          subscription.inactive!
        end
        if payment
          payment.update_attributes(status: "failed", full_response: charge.to_json)
        else
          payment = Payment.create!(
              user_id: user.id, price_cents: invoice.amount_paid,
              status: "failed", reference: Payment.generate_reference,
              payment_method: "stripe", response_id: invoice.id,
              full_response: charge.to_json)
          payment.payment_line_items.create!(
              buyable: subscription, price_cents: invoice.amount_paid)
        end
        @success = true
      end
    end

    def payment
      @payment ||= Payment.find_by response_id: invoice.id
    end

    def invoice
      @event.data.object
    end

    def current_subscription
       @current_subscription ||= user.current_subscription
    end

    def subscription
      @subscription ||= Subscription.find_by(remote_id: invoice.subscription)
    end

    def user
      @user ||= User.find_by(stripe_id: invoice.customer)
    end

    def charge
      @charge ||= Stripe::Charge.retrieve(invoice.charge)
    end

  end

end
