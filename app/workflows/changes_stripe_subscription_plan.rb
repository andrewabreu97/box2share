class ChangesStripeSubscriptionPlan

  attr_accessor :subscription_id, :user, :success, :new_plan_id

  def initialize(subscription_id:, user:, new_plan_id:)
    @subscription_id = subscription_id
    @new_plan_id = new_plan_id
    @user = user
    @success = false
  end

  def new_plan
    @plan ||= Plan.find_by(id: new_plan_id)
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
      return if customer.nil? || remote_subscription.nil?
      remote_subscription.plan = new_plan.remote_id
      subscription.update(plan: new_plan)
      remote_subscription.save
      SubscriptionMailer.notify_change_subscription(user, subscription).deliver_now
      @success = true
    end
  end

end
