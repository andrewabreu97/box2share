namespace :cloud_storage_service do
  desc "Create plans on the application"
  task create_plans: :environment do
    plans = [
        {remote_id: "starter_monthly", plan_name: "Starter",
         price_cents: 0, interval: "monthly", space_allowed: 1
        },
        {remote_id: "standard_monthly", plan_name: "Standard",
         price_cents: 6_000, interval: "monthly", space_allowed: 2
        },
        {remote_id: "professional_monthly", plan_name: "Professional",
         price_cents: 12_000, interval: "monthly", space_allowed: 3
        }
      ]
    Plan.transaction do
      plans.each { |plan_data| CreatesPlan.new(**plan_data).run }
    end
  end

end
