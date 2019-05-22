FactoryBot.define do

  factory :plan do

    name { "Starter" }
    type { "FreePlan" }
    status { :active }

  end

end
