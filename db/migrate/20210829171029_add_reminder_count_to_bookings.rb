class AddReminderCountToBookings < ActiveRecord::Migration[6.1]
  def change
    add_column :bookings, :reminder_count, :integer, default: 0
  end
end
