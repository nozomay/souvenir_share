class ChangeRelationshipsColumnsToReferences < ActiveRecord::Migration[5.2]
  def change
    remove_column :relationships, :follower_id, :integer
    remove_column :relationships, :followed_id, :integer
    add_reference :relationships, :follower, foreign_key: true
    add_reference :relationships, :followed, foreign_key: true
  end
end
