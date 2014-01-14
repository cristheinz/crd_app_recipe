class AddIndexToSourcesPublic < ActiveRecord::Migration
  def change
  	add_index :sources, :public
  end
end
