require 'rails_helper'

RSpec.feature "User sign out", type: :feature do

	scenario "successfully after sign in" do

		create(:user, email: "test@example.com", password: "foobar")

		sign_in "test@example.com", "foobar"
		
		click_link I18n.t('pages.header.navigation_links.signout')

		expect(current_path).to eq root_path
	  	expect(page).to have_content I18n.t('devise.sessions.signed_out')
	  	expect(page).not_to have_content "test@example.com"	

	end

end
