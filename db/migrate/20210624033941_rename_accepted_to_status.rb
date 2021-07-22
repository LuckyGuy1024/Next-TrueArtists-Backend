class RenameAcceptedToStatus < ActiveRecord::Migration[6.0]
  def up
    change_column :studio_invites, :accepted, :string, null: false, default: 'pending'
    rename_column :studio_invites, :accepted, :status
  end

  def down
    change_column :studio_invites, :status, :boolean, using: 'status::boolean', default: nil
    rename_column :studio_invites, :status, :accepted
  end
end
