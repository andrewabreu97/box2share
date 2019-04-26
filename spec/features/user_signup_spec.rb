require 'rails_helper'

RSpec.feature "User sign up", type: :feature do
  
  scenario "with valid information" do
  	
  	visit root_path
  	click_link I18n.t('pages.header.navigation_links.signup')
  	expect(current_path).to eq(new_user_registration_path)

  	fill_in "Name", with: "test-name"
  	fill_in "Last name", with: "test-last-name"
  	fill_in "Email", with: "test@domain.com"
  	fill_in "Password", with: "test-password"
  	fill_in "Password confirmation", with: "test-password"

  	click_button I18n.t('devise.registrations.new.sign_up')

  	expect(current_path).to eq root_path
  	expect(page).to have_content(I18n.t('devise.registrations.signed_up_but_unconfirmed'))

  	open_email "test@domain.com", with_subject: I18n.t('devise.mailer.confirmation_instructions.subject')
  	visit_in_email I18n.t('devise.mailer.confirmation_instructions.action')

  	expect(current_path).to eq new_user_session_path
  	expect(page).to have_content I18n.t('devise.confirmations.confirmed')

  	fill_in "Email", with: "test@domain.com"
  	fill_in "Password", with: "test-password"
  	click_button I18n.t('devise.sessions.new.sign_in')

  	expect(current_path).to eq root_path
  	expect(page).to have_content I18n.t('devise.sessions.signed_in')

  end

end
