class AddPublicToSources < ActiveRecord::Migration
  def change
    add_column :sources, :public, :boolean
  end
end
