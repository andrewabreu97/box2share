FactoryBot.define do
  factory :subscription do
    user { nil }
    plan { nil }
    start_date { "2019-05-05" }
    end_date { "2019-05-05" }
    status { 1 }
    payment_method { "MyString" }
    remote_id { "MyString" }
  end
end
