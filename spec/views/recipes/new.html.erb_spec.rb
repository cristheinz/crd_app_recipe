require 'spec_helper'

describe "recipes/new" do
  before(:each) do
    assign(:recipe, stub_model(Recipe,
      :name => "MyString",
      :description => "MyText",
      :portions => 1,
      :calories => 1
    ).as_new_record)
  end

  it "renders new recipe form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => recipes_path, :method => "post" do
      assert_select "input#recipe_name", :name => "recipe[name]"
      assert_select "textarea#recipe_description", :name => "recipe[description]"
      assert_select "input#recipe_portions", :name => "recipe[portions]"
      assert_select "input#recipe_calories", :name => "recipe[calories]"
    end
  end
end
