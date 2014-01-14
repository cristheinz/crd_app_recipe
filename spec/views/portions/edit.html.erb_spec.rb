require 'spec_helper'

describe "portions/edit" do
  before(:each) do
    @portion = assign(:portion, stub_model(Portion,
      :portion => "MyString",
      :recipe_id => 1,
      :ingredient_id => 1
    ))
  end

  it "renders the edit portion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => portions_path(@portion), :method => "post" do
      assert_select "input#portion_portion", :name => "portion[portion]"
      assert_select "input#portion_recipe_id", :name => "portion[recipe_id]"
      assert_select "input#portion_ingredient_id", :name => "portion[ingredient_id]"
    end
  end
end
