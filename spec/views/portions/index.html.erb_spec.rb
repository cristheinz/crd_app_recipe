require 'spec_helper'

describe "portions/index" do
  before(:each) do
    assign(:portions, [
      stub_model(Portion,
        :portion => "Portion",
        :recipe_id => 1,
        :ingredient_id => 2
      ),
      stub_model(Portion,
        :portion => "Portion",
        :recipe_id => 1,
        :ingredient_id => 2
      )
    ])
  end

  it "renders a list of portions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Portion".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
