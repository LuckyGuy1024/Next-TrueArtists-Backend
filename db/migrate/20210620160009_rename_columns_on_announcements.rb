class RenameColumnsOnAnnouncements < ActiveRecord::Migration[6.0]
  def change
    rename_column :announcements, :send_when, :publish_on
  end
end
