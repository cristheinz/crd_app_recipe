class AddSourceIdToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :source_id, :integer
    add_index :recipes, [:source_id]
  end
end
