require 'spec_helper'

describe "portions/show" do
  before(:each) do
    @portion = assign(:portion, stub_model(Portion,
      :portion => "Portion",
      :recipe_id => 1,
      :ingredient_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Portion/)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
