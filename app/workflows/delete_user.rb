class DeleteUser

  attr_accessor :subscription_id, :user, :success

  def initialize(subscription_id:, user:)
    @subscription_id = subscription_id
    @user = user
    @success = false
  end

  def subscription
    @subscription ||= Subscription.find_by(id: subscription_id)
  end

  def customer
    @customer ||= StripeCustomer.new(user: user)
  end

  def remote_subscription
    @remote_subscription ||=
        customer.subscriptions.retrieve(subscription.remote_id)
  end

  def user_is_subscribed?
    subscription_id && user.subscriptions.map(&:id).include?(subscription_id.to_i)
  end

  def run
    Subscription.transaction do
      return unless user_is_subscribed?
      unless subscription.free?
        return if customer.nil? || remote_subscription.nil?
        remote_subscription.delete
      end
      if user.destroy
        @success = true
      end
    end
  end

end
