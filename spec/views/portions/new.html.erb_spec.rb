require 'spec_helper'

describe "portions/new" do
  before(:each) do
    assign(:portion, stub_model(Portion,
      :portion => "MyString",
      :recipe_id => 1,
      :ingredient_id => 1
    ).as_new_record)
  end

  it "renders new portion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => portions_path, :method => "post" do
      assert_select "input#portion_portion", :name => "portion[portion]"
      assert_select "input#portion_recipe_id", :name => "portion[recipe_id]"
      assert_select "input#portion_ingredient_id", :name => "portion[ingredient_id]"
    end
  end
end
