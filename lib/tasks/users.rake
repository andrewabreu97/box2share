
namespace :users do
  desc "Create users in Box2Share application"
  task create: :environment do
    Faker::Config.locale = :en
    clear_database if Rails.env.development?
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
    puts "Destroy all subscription in Stripe account."
    invoke_task('subscriptions:destroy')
  end

  def destroy_plans
    puts "Destroy all plans in local and Stripe account."
    ['free_plan:destroy', 'paid_plans:destroy'].each do |task|
      invoke_task(task)
    end
  end

  def create_plans
    puts "Create plans in local and Stripe account."
    ['free_plan:create', 'paid_plans:create'].each do |task|
      invoke_task(task)
    end
  end

  def invoke_task(task)
    Rake::Task[task].invoke
  end

  def create_admin_user
    puts "Create admin user."
    user = User.create!(name: "Usuario",
      last_name: "Administrador",
      email: "admin@box2share.com",
      password: "foobar",
      password_confirmation: "foobar",
      admin: true,
      confirmed_at: Time.zone.now)
    create_folders(user)
  end

  def create_users_with_free_subscriptions
    puts "Create users with free subscriptions"
    5.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.free_email("#{first_name} #{last_name}")
      password = "foobar"
      user = User.new(name: first_name,
        last_name: last_name,
        email: email,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.zone.now)
      user.remote_avatar_url = Faker::Avatar.image(email, "300x300", "png", "set1", "bg1")
      user.save!
      create_folders(user)
    end
  end

  def create_users_with_paid_subscriptions
    standard_monthly_plan = Plan.find_by_remote_id("standard_monthly")
    standard_yearly_plan = Plan.find_by_remote_id("standard_yearly")

    professional_monthly_plan = Plan.find_by_remote_id("professional_monthly")
    professional_yearly_plan = Plan.find_by_remote_id("professional_yearly")

    card_params = {
      credit_card_number: '4242424242424242',
      expiration_month: 6,
      expiration_year: 2020,
      cvc: '314'
    }

    puts "Create users with paid subscriptions to Standard plan"

    2.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.free_email("#{first_name} #{last_name}")
      password = "foobar"
      user = User.new(name: first_name,
        last_name: last_name,
        email: email,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.zone.now)
      user.remote_avatar_url = Faker::Avatar.image(email, "300x300", "png", "set1", "bg1")
      user.save!
      create_folders(user)
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
      puts "The #{first_name} #{last_name} user has been created. Waiting for the first payment."
      sleep 30
    end

    2.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.free_email("#{first_name} #{last_name}")
      password = "foobar"
      user = User.new(name: first_name,
        last_name: last_name,
        email: email,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.zone.now)
      user.remote_avatar_url = Faker::Avatar.image(email, "300x300", "png", "set1", "bg1")
      user.save!
      create_folders(user)
      subscription = Subscription.create!(
          user: user, plan: standard_yearly_plan,
          start_date: Time.zone.now.to_date,
          end_date: standard_yearly_plan.end_date_from,
          status: :waiting, type: "PaidSubscription")
      stripe_token = StripeToken.new(**card_params)
      stripe_customer = StripeCustomer.new(user: user)
      return unless stripe_customer.valid?
      stripe_customer.source = stripe_token
      stripe_customer.save_non_sensible_card_info
      subscription.make_stripe_payment(stripe_customer)
      stripe_customer.add_subscription(subscription)
      puts "The #{first_name} #{last_name} user has been created. Waiting for the first payment."
      sleep 30
    end

    puts "Create users with paid subscriptions to Professional plan"

    2.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.free_email("#{first_name} #{last_name}")
      password = "foobar"
      user = User.new(name: first_name,
        last_name: last_name,
        email: email,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.zone.now)
      user.remote_avatar_url = Faker::Avatar.image(email, "300x300", "png", "set1", "bg1")
      user.save!
      create_folders(user)
      subscription = Subscription.create!(
          user: user, plan: professional_monthly_plan,
          start_date: Time.zone.now.to_date,
          end_date: professional_monthly_plan.end_date_from,
          status: :waiting, type: "PaidSubscription")
      stripe_token = StripeToken.new(**card_params)
      stripe_customer = StripeCustomer.new(user: user)
      return unless stripe_customer.valid?
      stripe_customer.source = stripe_token
      stripe_customer.save_non_sensible_card_info
      subscription.make_stripe_payment(stripe_customer)
      stripe_customer.add_subscription(subscription)
      puts "The #{first_name} #{last_name} user has been created. Waiting for the first payment."
      sleep 30
    end

    2.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.free_email("#{first_name} #{last_name}")
      password = "foobar"
      user = User.new(name: first_name,
        last_name: last_name,
        email: email,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.zone.now)
      user.remote_avatar_url = Faker::Avatar.image(email, "300x300", "png", "set1", "bg1")
      user.save!
      create_folders(user)
      subscription = Subscription.create!(
          user: user, plan: professional_yearly_plan,
          start_date: Time.zone.now.to_date,
          end_date: professional_yearly_plan.end_date_from,
          status: :waiting, type: "PaidSubscription")
      stripe_token = StripeToken.new(**card_params)
      stripe_customer = StripeCustomer.new(user: user)
      return unless stripe_customer.valid?
      stripe_customer.source = stripe_token
      stripe_customer.save_non_sensible_card_info
      subscription.make_stripe_payment(stripe_customer)
      stripe_customer.add_subscription(subscription)
      puts "The #{first_name} #{last_name} user has been created. Waiting for the first payment."
      sleep 30
    end

  end

  def create_folders(user)
    ["Documentos", "Imágenes", "Música", "Vídeos"].each do |folder_name|
      folder = user.folders.create!(name: folder_name)
      # assets = Dir["#{Rails.root}/public/resources/*"]
      # assets.each do |asset|
      #   create_assets(asset, user, folder)
      # end
    end
  end

  def create_assets(path, user, folder)
    file = File.open(path)
    blob = ActiveStorage::Blob.create_after_upload!(
      io: file,
      filename: File.basename(file)
    )
    user.assets.create!(name: blob.filename.base, uploaded_file: blob, folder_id: folder.id)
  end

end
