require "rails_helper"

RSpec.describe "routes for StaticPagesController", :type => :routing do

  it "routes / to the StaticPages controller" do
    expect(get("/")).to route_to("static_pages#home")
  end

end