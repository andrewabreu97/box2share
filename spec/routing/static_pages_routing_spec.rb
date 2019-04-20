require "rails_helper"

RSpec.describe "routes for StaticPagesController", :type => :routing do

  it "routes /home to the StaticPages controller" do
    expect(get("/home")).to route_to("static_pages#home")
  end

end