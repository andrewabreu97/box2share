require 'rails_helper'

RSpec.feature "User sign up", type: :feature do
  
  scenario "with valid information" do
  	
  	visit root_path
  	click_link I18n.t('pages.header.navigation_links.signup')
  	expect(current_path).to eq(new_user_registration_path)

    sign_up_with "test-name", "test-last-name", "test@example.com", "test-password", "test-password"

  	expect(current_path).to eq root_path
  	expect(page).to have_content(I18n.t('devise.registrations.signed_up_but_unconfirmed'))

  	open_email "test@example.com", with_subject: I18n.t('devise.mailer.confirmation_instructions.subject')
  	visit_in_email I18n.t('devise.mailer.confirmation_instructions.action')

  	expect(current_path).to eq new_user_session_path
  	expect(page).to have_content I18n.t('devise.confirmations.confirmed')

    sign_in_with "test@example.com", "test-password"

  	expect(current_path).to eq root_path
  	expect(page).to have_content I18n.t('devise.sessions.signed_in')

  end

  context "with invalid information" do
  	
    before do
      visit new_user_registration_path
    end

  	scenario "with blank fields" do
  	
      expect_fields_to_be_blank

	    click_button I18n.t('devise.registrations.new.sign_up')

      expect(page).to have_content I18n.t('errors.messages.not_saved.other', count: 4)
 
  	end

  	scenario "with incorrect password confirmation" do
  		
      sign_up_with "test-name", "test-last-name", "test@example.com", "test-password", "not-test-password"

      expect(page).to have_content I18n.t('errors.messages.not_saved.one')

  	end

    scenario "with already registered email" do

      create(:user, email: "test@example.com")

      sign_up_with "test-name", "test-last-name", "test@example.com", "test-password", "test-password"

      expect(page).to have_content I18n.t('errors.messages.not_saved.one')

    end  

    scenario "with invalid email" do

      sign_up_with "test-name", "test-last-name", "invalid-email-for-testing", "test-password", "test-password"

      expect(page).to have_content I18n.t('errors.messages.not_saved.one')    

    end

    scenario "with too short password" do
      
      min_password_length = 6
      too_short_password = "p" * (min_password_length - 1)

      sign_up_with "test-name", "test-last-name", "test@example.com", too_short_password, too_short_password

      expect(page).to have_content I18n.t('errors.messages.not_saved.one')

    end   

  end

  private

    def expect_fields_to_be_blank
      expect(find_field("Name", type: "text").value).to be_nil
      expect(find_field("Last name", type: "text").value).to be_nil
      expect(page).to have_field("Email", with: "", type: "email")
      expect(find_field("Password", type: "password").value).to be_nil
      expect(find_field("Password confirmation", type: "password").value).to be_nil          
    end

    def sign_up_with(name, last_name, email, password, password_confirmation)
      fill_in "Name", with: name
      fill_in "Last name", with: last_name
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Password confirmation", with: password_confirmation

      click_button I18n.t('devise.registrations.new.sign_up')      
    end

    def sign_in_with(email, password)
      fill_in "Email", with: email
      fill_in "Password", with: password
      click_button I18n.t('devise.sessions.new.sign_in')
    end

end
