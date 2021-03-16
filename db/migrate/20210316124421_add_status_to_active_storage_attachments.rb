class AddStatusToActiveStorageAttachments < ActiveRecord::Migration[6.0]
  def change
    add_column :active_storage_attachments, :status, :string, default: 'approved'
  end
end
