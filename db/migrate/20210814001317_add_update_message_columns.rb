class AddUpdateMessageColumns < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :conversation_id, :integer
    add_column :bookings, :conversation_id, :integer

    remove_column :bookings, :message_id

    add_index :bookings, :conversation_id
    add_index :messages, :conversation_id
  end
end
