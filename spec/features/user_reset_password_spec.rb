require 'rails_helper'

RSpec.feature "User reset password", type: :feature do

	scenario "with valid information" do
		
		user = create(:user, email: "test@example.com", password: "foobar")

		visit root_path

		click_link I18n.t('pages.header.navigation_links.signin')
		expect(current_path).to eq new_user_session_path

		click_link I18n.t('devise.shared.links.forgot_your_password')
		expect(current_path).to eq new_user_password_path

		fill_in "Email", with: "test@example.com"
		click_button I18n.t('devise.passwords.new.send_me_reset_password_instructions')

		expect(current_path).to eq new_user_session_path
		expect(page).to have_content I18n.t('devise.passwords.send_instructions')

	  	open_email "test@example.com", with_subject: I18n.t('devise.mailer.reset_password_instructions.subject')
	  	visit_in_email I18n.t('devise.mailer.reset_password_instructions.action')		

	  	expect(current_path).to eq edit_user_password_path

  		fill_in "New password", with: "123456"
  		fill_in "Confirm new password", with: "123456"
  		click_button I18n.t('devise.passwords.edit.change_my_password')

  		expect(current_path).to eq root_path
		expect(page).to have_content I18n.t('devise.passwords.updated')

	end


end
