require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  
	scenario "viewing the home page" do
		visit root_path

		expect(page).to have_title("Inicio | Box2Share")
		
		expect(page).to have_link(I18n.t('pages.header.navigation_links.home'), :href => root_path(locale: I18n.locale))
		expect(page).to have_link(I18n.t('pages.header.navigation_links.pricing'), :href => '#')	
		expect(page).to have_link(I18n.t('pages.header.navigation_links.signin'), :href => new_user_session_path(locale: I18n.locale))	
		expect(page).to have_link(I18n.t('pages.header.navigation_links.signup'), :href => new_user_registration_path(locale: I18n.locale))
	end

end
