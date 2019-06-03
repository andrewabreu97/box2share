require 'rails_helper'

RSpec.describe "assets/edit", type: :view do
  before(:each) do
    @asset = assign(:asset, Asset.create!())
  end

  it "renders the edit asset form" do
    render

    assert_select "form[action=?][method=?]", asset_path(@asset), "post" do
    end
  end
end
