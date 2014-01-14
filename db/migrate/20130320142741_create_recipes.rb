class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :description
      t.integer :portions
      t.integer :calories

      t.timestamps
    end
  end
end
