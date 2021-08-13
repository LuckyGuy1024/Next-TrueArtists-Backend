class AddThreadIdToMessage < ActiveRecord::Migration[6.0]
  def up
    # add_column :messages, :thread_id, :string
    change_column :messages, :sender_id, :integer
  end

  def down
    change_column :messages, :sender_id, :string
    remove_column :messages, :thread_id
  end
end
