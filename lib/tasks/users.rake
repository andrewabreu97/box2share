
namespace :users do
  desc "Create users in Box2Share application"
  task create: :environment do
    clear_database
    destroy_subscriptions
    destroy_plans
    create_plans
    create_admin_user
    create_users_with_free_subscriptions
    create_users_with_paid_subscriptions
  end

  task destroy: :environment do
  end

  def clear_database
    invoke_task('db:reset')
  end

  def destroy_subscriptions
    invoke_task('subscriptions:destroy')
  end

  def destroy_plans
    ['free_plan:destroy', 'paid_plans:destroy'].each do |task|
      invoke_task(task)
    end
  end

  def create_plans
    ['free_plan:create', 'paid_plans:create'].each do |task|
      invoke_task(task)
    end
  end

  def invoke_task(task)
    Rake::Task[task].invoke
  end

  def create_admin_user
    User.create!(name: "Usuario",
      last_name: "Administrador",
      email: "admin@box2share.com",
      password: "foobar",
      password_confirmation: "foobar",
      admin: true,
      confirmed_at: Time.zone.now)
  end

  def create_users_with_free_subscriptions
    10.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.free_email("#{first_name} #{last_name}")
      password = "foobar"
      User.create!(name: first_name,
        last_name: last_name,
        email: email,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.zone.now)
    end
  end

  def create_users_with_paid_subscriptions
    standard_monthly_plan = Plan.find_by_remote_id("standard_monthly")
    card_params = {
      credit_card_number: '4242424242424242',
      expiration_month: 6,
      expiration_year: 2020,
      cvc: '314'
    }
    10.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.free_email("#{first_name} #{last_name}")
      password = "foobar"
      user = User.create!(name: first_name,
        last_name: last_name,
        email: email,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.zone.now)
      subscription = Subscription.create!(
          user: user, plan: standard_monthly_plan,
          start_date: Time.zone.now.to_date,
          end_date: standard_monthly_plan.end_date_from,
          status: :waiting, type: "PaidSubscription")
      stripe_token = StripeToken.new(**card_params)
      stripe_customer = StripeCustomer.new(user: user)
      return unless stripe_customer.valid?
      stripe_customer.source = stripe_token
      stripe_customer.save_non_sensible_card_info
      subscription.make_stripe_payment(stripe_customer)
      stripe_customer.add_subscription(subscription)
      puts "El usuario #{first_name} #{last_name} se ha creado. Falta recibir el pago."
      sleep 30
    end
  end

end
