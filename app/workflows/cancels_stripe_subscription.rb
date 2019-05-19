class CancelsStripeSubscription

  attr_accessor :subscription_id, :user, :success

  def initialize(subscription_id:, user:)
    @subscription_id = subscription_id
    @user = user
    @success = false
  end

  def free_subscription
    @free_subscription ||= user.subscriptions.find_by(type: "FreeSubscription")
  end

  def subscription
    @subscription ||= Subscription.find_by(id: subscription_id)
  end

  def customer
    @customer ||= StripeCustomer.new(user: user)
  end

  def remote_subscription
    @remote_subscription ||=
        customer. subscriptions.retrieve(subscription.remote_id)
  end

  def user_is_subscribed?
    subscription_id && user.subscriptions.map(&:id).include?(subscription_id.to_i)
  end

  def run
    Subscription.transaction do
      return unless user_is_subscribed?
      return if customer.nil? || remote_subscription.nil?
      remote_subscription.delete
      subscription.canceled!
      free_subscription.active!
      SubscriptionMailer.notify_user_cancellation(user, subscription).deliver_now
      @success = true
    end
  end

end
