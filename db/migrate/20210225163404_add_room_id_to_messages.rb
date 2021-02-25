class AddRoomIdToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :room_id, :string
  end
end
