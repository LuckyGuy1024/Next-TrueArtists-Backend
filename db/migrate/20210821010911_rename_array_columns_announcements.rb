class RenameArrayColumnsAnnouncements < ActiveRecord::Migration[6.1]
  def change
    change_column :announcements, :custom_emails, :text
    change_column :announcements, :recipients, :text
  end
end
