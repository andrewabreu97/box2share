require 'rails_helper'

RSpec.describe "assets/index", type: :view do
  before(:each) do
    assign(:assets, [
      Asset.create!(),
      Asset.create!()
    ])
  end

  it "renders a list of assets" do
    render
  end
end
