FactoryBot.define do

	factory :user do

		transient do
			skip_confirmation { true }
		end

		name { 'Name' }
		last_name { 'Last Name' }
		sequence(:email) { |n| "test#{n}@example.com" }
		password { 'foobar' }
		password_confirmation { 'foobar' }

		before(:create) do |user, evaluator|
			user.skip_confirmation! if evaluator.skip_confirmation
		end

	end

end

