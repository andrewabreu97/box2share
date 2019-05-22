require 'rails_helper'

RSpec.feature "User cancel accounts", type: :feature do

	scenario "successfully after sign in", js: true do

		create(:user, email: "test@example.com", password: "foobar")

		sign_in "test@example.com", "foobar"

		page.find("#userDropdown").click
		click_link I18n.t('layouts.header.links.profile')

		expect(current_path).to eq edit_user_registration_path

		page.accept_confirm do
			click_button I18n.t('devise.registrations.edit.cancel_my_account')
		end

		expect(page).to have_content I18n.t('devise.registrations.destroyed')

	end

end
