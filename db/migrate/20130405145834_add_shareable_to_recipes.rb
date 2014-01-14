class AddShareableToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :shareable, :boolean, default: false
  end
end
