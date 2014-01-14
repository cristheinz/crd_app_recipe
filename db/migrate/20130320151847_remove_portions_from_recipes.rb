class RemovePortionsFromRecipes < ActiveRecord::Migration
  def up
    remove_column :recipes, :portions
  end

  def down
    add_column :recipes, :portions, :integer
  end
end
