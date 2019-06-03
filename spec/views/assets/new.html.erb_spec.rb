require 'rails_helper'

RSpec.describe "assets/new", type: :view do
  before(:each) do
    assign(:asset, Asset.new())
  end

  it "renders new asset form" do
    render

    assert_select "form[action=?][method=?]", assets_path, "post" do
    end
  end
end
