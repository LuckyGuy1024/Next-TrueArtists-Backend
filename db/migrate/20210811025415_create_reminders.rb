class CreateReminders < ActiveRecord::Migration[6.1]
  def change
    create_table :reminders do |t|
      t.integer :complete_profile, default: 0
      t.references :user

      t.timestamps
    end
  end
end
