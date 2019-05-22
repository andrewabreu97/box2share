require 'rails_helper'

RSpec.feature "User edit profile", type: :feature do

	before(:each) do
		create(:plan)
		create(:user, email: "test@example.com", password: "foobar")
		sign_in "test@example.com", "foobar"
		click_link I18n.t('layouts.header.links.profile')
		expect(current_path).to eq edit_user_registration_path
	end

	context "with valid information" do

		scenario "change name and last name values and setting current password" do

			fill_in "Name", with: "Test Name 2"
			fill_in "Last name", with: "Test Last Name 2"

			fill_in "Current password", with: "foobar"

			click_button I18n.t('devise.registrations.edit.update')

			expect(current_path).to eq root_path
			expect(page).to have_content I18n.t('devise.registrations.updated')

		end

		scenario "change password and setting current password" do

			fill_in "Password", with: "123456"
			fill_in "Password confirmation", with: "123456"

			fill_in "Current password", with: "foobar"

			click_button I18n.t('devise.registrations.edit.update')

			expect(current_path).to eq root_path
			expect(page).to have_content I18n.t('devise.registrations.updated')

		end

		scenario "change email and confirm via email" do

			fill_in "Email", with: "another-test@example.com"

			fill_in "Current password", with: "foobar"

			click_button I18n.t('devise.registrations.edit.update')

			expect(current_path).to eq root_path
			expect(page).to have_content I18n.t('devise.registrations.update_needs_confirmation')

	  	open_email "another-test@example.com", with_subject: I18n.t('devise.mailer.confirmation_instructions.subject')
  		visit_in_email I18n.t('devise.mailer.confirmation_instructions.action')

			expect(current_path).to eq root_path
			expect(page).to have_content I18n.t('devise.confirmations.confirmed')

		end

	end

	context "with invalid information" do

		scenario "change name and last name values and not setting current password" do

			fill_in "Name", with: "Test Name 2"
			fill_in "Last name", with: "Test Last Name 2"

			expect(find_field("Current password", type: "password").value).to be_nil

			click_button I18n.t('devise.registrations.edit.update')

			expect(current_path).to eq user_registration_path
			expect(page).to have_content I18n.t('errors.messages.not_saved.one')

		end

	end

end
