class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.string :email
      t.string :message

      t.timestamps
    end
    add_index :feedbacks, :email
  end
end
