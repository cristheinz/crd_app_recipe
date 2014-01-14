class AddNewColsToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :pax, :string
    add_column :recipes, :prep_time, :string
    add_column :recipes, :difficult_level, :string
    add_column :recipes, :page, :string
  end
end
