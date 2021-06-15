class RenameColumnVerifiedToStatus < ActiveRecord::Migration[6.0]
  def change
    rename_column :conventions, :verified, :status
  end
end
