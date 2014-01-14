class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.date :publish_date

      t.timestamps
    end
  end
end
