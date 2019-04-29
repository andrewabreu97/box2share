module Features

  module SessionHelpers

    def sign_up_with(name, last_name, email, password, confirmation)
      visit new_user_registration_path
      fill_in "Name", with: name
      fill_in "Last name", with: last_name
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Password confirmation", with: confirmation
      click_button I18n.t('devise.registrations.new.sign_up')
    end

    def signin(email, password)
      visit new_user_session_path
      fill_in "Email", with: email
      fill_in "Password", with: password
      click_button I18n.t('devise.sessions.new.sign_in')
    end

  end

end