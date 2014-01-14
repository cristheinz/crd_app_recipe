class AddPartToPortion < ActiveRecord::Migration
  def change
    add_column :portions, :part, :string
  end
end
