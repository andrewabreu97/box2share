require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /static_pages/home" do

    it "should render home template" do
      get root_path
      expect(response).to render_template(:home)
    end

    it "should return a 200 http status code" do 
			get root_path
			expect(response).to have_http_status(:ok)
		end

  end
end
