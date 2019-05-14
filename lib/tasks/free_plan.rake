namespace :free_plan do

  desc "Create free plan"
  task create: :environment do
    plan = [
      {name: 'Starter', space_allowed: 1}
    ]
    Plan.transaction do
      plan.each { |plan_data| CreatesFreePlan.new(**plan_data).run }
    end
  end

  desc "Destroy free plan"
  task destroy: :environment do
    Plan.transaction do
      Plan.free_plan.destroy_all
    end
  end

end
