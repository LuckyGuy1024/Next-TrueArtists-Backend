class FixBrokenMessageMigrations < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :thread_id, :string,  if_not_exists: true
    add_index :messages, :thread_id, if_not_exists: true
  end
end
