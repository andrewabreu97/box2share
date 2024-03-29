class StripeCustomer

  attr_accessor :user

  delegate :subscriptions, :id, to: :remote_customer

  def initialize(user: nil)
    @user = user
  end

  def remote_customer
    @remote_customer ||= begin
      if user.stripe_id
        Stripe::Customer.retrieve(user.stripe_id)
      else
        Stripe::Customer.create(email: user.email).tap do |remote_customer|
          user.update!(stripe_id: remote_customer.id)
        end
      end
    end
  end

  def valid?
    remote_customer.present?
  end

  def find_subscription_for(plan)
    subscriptions.find { |s| s.plan.id == plan.remote_id }
  end

  def add_subscription(subscription)
    remote_subscription = remote_customer.subscriptions.create(
        plan: subscription.remote_plan_id, enable_incomplete_payments: true)
    subscription.update!(remote_id: remote_subscription.id)
  end

  def save_non_sensible_card_info
    source = remote_customer.sources.first
    card_brand = source.brand
    card_last4 = source.last4
    user.update_attributes(card_brand: card_brand, card_last4: card_last4)
  end

  def source=(token)
    remote_customer.source = token.id
    remote_customer.save
  end

end
