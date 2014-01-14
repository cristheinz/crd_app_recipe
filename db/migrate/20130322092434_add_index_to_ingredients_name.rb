class AddIndexToIngredientsName < ActiveRecord::Migration
  def change
  	add_index :ingredients, :name, unique: true
  end
end
