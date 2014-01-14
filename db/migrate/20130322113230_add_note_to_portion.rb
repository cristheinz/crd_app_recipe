class AddNoteToPortion < ActiveRecord::Migration
  def change
    add_column :portions, :note, :string
  end
end
