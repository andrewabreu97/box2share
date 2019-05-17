module StripeHandler

  class CustomerSubscriptionDeleted

    attr_accessor :event, :success, :payment

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

    def free_subscription
      @free_subscription ||= user.subscriptions.find_by(type: "FreeSubscription")
    end

    def run
      Subscription.transaction do
        subscription&.canceled!
        free_subscription.active!
      end
    end

  end

end
