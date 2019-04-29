require 'rails_helper'

RSpec.feature "User sign in", type: :feature do

	# Spec will run using the ':selenium browser driver configured in spec/support/capybara.rb'
	scenario "with valid information", js: true do
		
		create(:user, email: "test@example.com", password: "foobar")

		visit root_path

		click_link I18n.t('pages.header.navigation_links.signin')
		expect(current_path).to eq new_user_session_path

		sign_in_with "test@example.com", "foobar"

  	expect(current_path).to eq root_path
  	expect(page).to have_content I18n.t('devise.sessions.signed_in')

	end

	scenario "unconfirmed user cannot login", js: true do
		
		create(:user, skip_confirmation: false, email: "test@example.com", password: "foobar")

		visit new_user_session_path

		sign_in_with "test@example.com", "foobar"

		expect(current_path).to eq new_user_session_path
  	expect(page).not_to have_content I18n.t('devise.sessions.signed_in')
  	expect(page).to have_content I18n.t('devise.failure.unconfirmed')  			

	end

	private
    def sign_in_with(email, password)
      fill_in "Email", with: email
      fill_in "Password", with: password
      click_button I18n.t('devise.sessions.new.sign_in')
    end

end
