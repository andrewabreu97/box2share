namespace :paid_plans do
  desc "Create paid plans"
  task create: :environment do
    product = {id: "box2share", name: "Box2Share", type: "service"}
    plans = [
        {remote_id: "standard_monthly", name: "Standard", price_cents: 600,
          interval: "month", interval_count: 1, space_allowed: 2
        },
        {remote_id: "professional_monthly", name: "Professional", price_cents: 1200,
          interval: "month", interval_count: 1, space_allowed: 3
        },
        {remote_id: "standard_yearly", name: "Standard", price_cents: 7_200,
          interval: "year", interval_count: 1, space_allowed: 2
        },
        {remote_id: "professional_yearly", name: "Professional", price_cents: 14_400,
          interval: "year", interval_count: 1, space_allowed: 3
        }
      ]
    Plan.transaction do
      Stripe::Product.create(**product)
    end
    Plan.transaction do
      plans.each { |plan_data| CreatesPaidPlan.new(**plan_data).run }
    end
  end

  desc "Destroy paid plans"
  task destroy: :environment do
    product = {id: "box2share", name: "Box2Share", type: "service"}
    plans = [
        {remote_id: "standard_monthly", name: "Standard", price_cents: 600,
          interval: "month", interval_count: 1, space_allowed: 2
        },
        {remote_id: "professional_monthly", name: "Professional", price_cents: 1200,
          interval: "month", interval_count: 1, space_allowed: 3
        },
        {remote_id: "standard_yearly", name: "Standard", price_cents: 7_200,
          interval: "year", interval_count: 1, space_allowed: 2
        },
        {remote_id: "professional_yearly", name: "Professional", price_cents: 14_400,
          interval: "year", interval_count: 1, space_allowed: 3
        }
      ]
    Plan.transaction do
      plans.each do | plan_data |
        begin
          Stripe::Plan.delete(plan_data[:remote_id])
        rescue Stripe::StripeError => exception
          puts "No existe el plan con id: #{plan_data[:remote_id]} en tu cuenta de Stripe"
        end
      end
      Plan.paid_plan.destroy_all
    end
    Plan.transaction do
      begin
        Stripe::Product.delete(product[:id])
      rescue Stripe::StripeError => exception
        puts "No existe el producto con id: #{product[:id]} en tu cuenta de Stripe"
      end
    end
  end

end
