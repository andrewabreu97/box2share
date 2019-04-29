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
  		
  		fill_in "Name", with: "test-name"
  		fill_in "Last name", with: "test-last-name"
      fill_in "Email", with: "test@domain.com"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "not-test-password"
      click_button I18n.t('devise.registrations.new.sign_up')

      expect(page).to have_content I18n.t('errors.messages.not_saved.one')

  	end

    scenario "with already registered email" do

      create(:user, email: "test@example.com")

      fill_in "Name", with: "test-name"
      fill_in "Last name", with: "test-last-name"
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "test-password"
      click_button I18n.t('devise.registrations.new.sign_up')

      expect(page).to have_content I18n.t('errors.messages.not_saved.one')

    end  

    scenario "with invalid email" do

      fill_in "Name", with: "test-name"
      fill_in "Last name", with: "test-last-name"
      fill_in "Email", with: "invalid-email-for-testing"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "test-password"
      click_button I18n.t('devise.registrations.new.sign_up')

      expect(page).to have_content I18n.t('errors.messages.not_saved.one')    

    end

    scenario "with too short password" do
      
      min_password_length = 6
      too_short_password = "p" * (min_password_length - 1)

      fill_in "Name", with: "test-name"
      fill_in "Last name", with: "test-last-name"
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: too_short_password
      fill_in "Password confirmation", with: too_short_password
      click_button I18n.t('devise.registrations.new.sign_up')

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

end
