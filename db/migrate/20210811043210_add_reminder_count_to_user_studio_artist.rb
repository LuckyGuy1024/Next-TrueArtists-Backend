class AddReminderCountToUserStudioArtist < ActiveRecord::Migration[6.1]
  def change
    add_column :studios, :reminder_count, :integer, default: 0
    add_column :artists, :reminder_count, :integer, default: 0
    add_column :users, :reminder_count, :integer, default: 0
  end
end
