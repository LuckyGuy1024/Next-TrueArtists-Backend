class RenameSenderIdToUser < ActiveRecord::Migration[6.1]
  def change
    rename_column :bookings, :sender_id, :user_id
    remove_column :bookings, :receiver_id
  end
end
