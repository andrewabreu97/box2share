require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do

	scenario "viewing the home page" do
		visit root_path

		expect(page).to have_title("#{I18n.t('static_pages.home.title')} | Box2Share")

		expect(page).to have_link(I18n.t('layouts.header.links.home'), href: root_path(locale: I18n.locale))
		expect(page).to have_link(I18n.t('layouts.header.links.pricing'), href: plans_path(locale: I18n.locale))
		expect(page).to have_link(I18n.t('layouts.header.links.signin'), href: new_user_session_path(locale: I18n.locale))
		expect(page).to have_link(I18n.t('layouts.header.links.signup'), href: new_user_registration_path(locale: I18n.locale))
	end

end
