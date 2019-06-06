FactoryBot.define do
  factory :folder do
    name { "MyString" }
    parent_id { 1 }
    user { nil }
  end
end
