class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title, null: false
      t.text :review, null: false
      t.float :rate
      t.string :address, null: false

      t.timestamps
    end
  end
end
