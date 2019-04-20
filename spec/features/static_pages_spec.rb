require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  
	scenario "viewing the home page" do
		visit root_path

		expect(page).to have_title("Inicio | Box2Share")
		
		expect(page).to have_link("Home", :href => root_path)
		expect(page).to have_link("Pricing", :href => '#')	
		expect(page).to have_link("Sign In", :href => '#')	
		expect(page).to have_link("Sign Up", :href => '#')
	end

end
