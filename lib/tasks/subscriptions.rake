namespace :subscriptions do
  desc ""
  task destroy: :environment do
    subscriptions_list = Stripe::Subscription.list()
    subscriptions_data = subscriptions_list.data
    subscriptions_data.each do |subscription|
      Stripe::Subscription.delete(subscription.id)
    end
  end

end
