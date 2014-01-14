class AddNoteToUsersmarks < ActiveRecord::Migration
  def change
    add_column :usersmarks, :note, :string
  end
end
