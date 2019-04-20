require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  
	scenario "viewing the home page" do
		visit home_path
		expect(page).to have_title("Inicio | Box2Share")
	end

end
