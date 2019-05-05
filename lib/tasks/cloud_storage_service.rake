namespace :cloud_storage_service do
  desc "Create plans on the application"
  task create_plans: :environment do
    product = {id: "box2share", name: "Box2Share", type: "service"}
    plans = [
        {remote_id: "starter_monthly", name: "Starter", price_cents: 0,
          interval: "month", interval_count: 1, space_allowed: 1
        },
        {remote_id: "standard_monthly", name: "Standard", price_cents: 600,
          interval: "month", interval_count: 1, space_allowed: 2
        },
        {remote_id: "professional_monthly", name: "Professional", price_cents: 1200,
          interval: "month", interval_count: 1, space_allowed: 3
        },
        {remote_id: "starter_yearly", name: "Starter", price_cents: 0,
          interval: "year", interval_count: 1, space_allowed: 1
        },
        {remote_id: "standard_yearly", name: "Standard", price_cents: 7_200,
          interval: "year", interval_count: 1, space_allowed: 2
        },
        {remote_id: "professional_yearly", name: "Professional", price_cents: 14_400,
          interval: "year", interval_count: 1, space_allowed: 3
        }
      ]
    Stripe::Product.create(**product)
    Plan.transaction do
      plans.each { |plan_data| CreatesPlan.new(**plan_data).run }
    end
  end

end
