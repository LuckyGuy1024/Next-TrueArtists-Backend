class CreateMessageMails < ActiveRecord::Migration[6.0]
  def change
    create_table :message_mails do |t|
      t.integer :message_id, null: false
      t.integer :user_id, null: false
      t.string  :thread_id
      t.string  :mail_message_id, null: false
      t.text    :references

      t.timestamps
    end
  end
end
