class CreateAnnouncements < ActiveRecord::Migration[6.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.integer :published_by, null: false, foreign_key: true
      t.boolean :send_now, default: false
      t.datetime :send_when
      t.text :content
      t.text :recipients, array: true, default: []
      t.text :custom_emails, array: true, default: []
      t.string :status

      t.timestamps
    end
  end
end
