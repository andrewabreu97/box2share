module StripeHandler

  class CustomerSubscriptionDeleted

    attr_accessor :event, :success

    def initialize(event)
      @event = event
      @success = false
    end

    def remote_subscription
      @event.data.object
    end

    def subscription
      @subscription ||= Subscription.find_by(remote_id: remote_subscription.id)
    end

    def user
      @user ||= User.find_by(stripe_id: invoice.customer)
    end

    def run
      Subscription.transaction do
        if subscription.active?
          subscription&.canceled!
          SubscriptionMailer.notify_stripe_cancellation(user, subscription).deliver_now
          @success = true
        end
      end
    end

  end

end
