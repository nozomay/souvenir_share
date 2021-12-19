class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :review, null: false
      t.float :rate
      t.string :address, null: false

      t.timestamps
    end
  end
end
