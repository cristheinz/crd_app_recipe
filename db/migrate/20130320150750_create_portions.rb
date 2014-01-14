class CreatePortions < ActiveRecord::Migration
  def change
    create_table :portions do |t|
      t.string :portion
      t.integer :recipe_id
      t.integer :ingredient_id

      t.timestamps
    end
  end
end
