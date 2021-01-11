class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string   "subject"
      t.text     "content"
      t.integer  "receiver_id"
      t.string   "sender_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "sender_deleted"
      t.boolean  "receiver_deleted"
      t.integer  "parent_id"
      t.string   "message_type"
      t.timestamps
    end
  end
end
