class AddNoteToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :note, :text
  end
end
