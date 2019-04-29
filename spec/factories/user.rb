FactoryBot.define do
	
	factory :user do

		name {'Name'}
		last_name {'Last name'}
		email {'test@domain.com'}
		password {'foobar'}
		confirmed_at { Time.now }

	end

end