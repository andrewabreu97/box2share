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
        if payment
          subscription.active!
          subscription.update_end_date
          user.free_subscription.inactive!
          payment.update_attributes!(status: "succeeded", full_response: charge.to_json)
          SubscriptionMailer.successful_payment(user, subscription, invoice).deliver_now
        else
          if subscription.pending_initial_payment?
            SubscriptionMailer.successful_subscription(user, subscription).deliver_now
          end
          subscription.active!
          subscription.update_end_date
          user.free_subscription.inactive!
          payment = Payment.create!(
              user_id: user.id, price_cents: invoice.amount_paid,
              status: "succeeded", reference: Payment.generate_reference,
              payment_method: "stripe", response_id: invoice.id,
              full_response: charge.to_json)
          payment.payment_line_items.create!(
              buyable: subscription, price_cents: invoice.amount_paid)
          SubscriptionMailer.successful_payment(user, subscription, invoice).deliver_now
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
      @subscription ||= Subscription.find_by(remote_id: invoice.lines.data[0].subscription)
    end

    def user
      @user ||= User.find_by(stripe_id: invoice.customer)
    end

    def charge
      @charge ||= Stripe::Charge.retrieve(invoice.charge)
    end

  end

end
