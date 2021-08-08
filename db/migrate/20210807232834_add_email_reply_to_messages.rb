class AddEmailReplyToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :email_client_reply, :boolean
  end
end
