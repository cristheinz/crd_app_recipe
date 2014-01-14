class CreateUsersmarks < ActiveRecord::Migration
  def change
    create_table :usersmarks do |t|
      t.integer :recipe_id
      t.integer :user_id
      t.integer :mark_type

      t.timestamps
    end
    add_index :usersmarks, [:user_id]
  end
end
