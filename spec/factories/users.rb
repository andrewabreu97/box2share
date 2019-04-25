FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    last_name {Faker::Name.last_name}
    email {Faker::Internet.email}
    password { 'foobar' }
    password_confirmation {'foobar'}
  end
end
