class AddIndexToRecipesShareable < ActiveRecord::Migration
  def change
  	add_index :recipes, :shareable
  end
end
