namespace :users do
  desc "Create users in Box2Share application"
  task create: :environment do
    clear_database
    destroy_plans
    create_plans
    create_admin_user
  end

  task destroy: :environment do
  end

  def clear_database
    Rake::Task['db:reset'].execute
  end

  def destroy_plans
    ['free_plan:destroy', 'paid_plans:destroy'].each do |task|
      Rake::Task[task].execute
    end
  end

  def create_plans
    ['free_plan:create', 'paid_plans:create'].each do |task|
      Rake::Task[task].execute
    end
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

end
