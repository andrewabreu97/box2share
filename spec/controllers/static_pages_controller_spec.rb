require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

	describe "GET #home" do

		it "should render home template" do 
			get :home 
			expect(response).to render_template(:home)
		end

		it "should return a 200 http status code" do
			get :home
			expect(response).to have_http_status(:ok)
		end

	end


end
