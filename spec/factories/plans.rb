FactoryBot.define do
  factory :plan do
    remote_id { "MyString" }
    name { "MyString" }
    price { "" }
    interval { 1 }
    interval_count { 1 }
    space_allowed { 1 }
    status { 1 }
    description { "MyText" }
  end
end
