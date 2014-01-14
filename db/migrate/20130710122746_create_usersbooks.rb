class CreateUsersbooks < ActiveRecord::Migration
  def change
    create_table :usersbooks do |t|
      t.integer :user_id
      t.integer :source_id

      t.timestamps
    end
    add_index :usersbooks, [:user_id]
  end
end
