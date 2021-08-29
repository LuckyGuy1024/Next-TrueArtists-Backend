class RenameArchiveToArchived < ActiveRecord::Migration[6.1]
  def change
    remove_column :conversations, :read
    rename_column :conversations, :archive, :archived
  end
end
