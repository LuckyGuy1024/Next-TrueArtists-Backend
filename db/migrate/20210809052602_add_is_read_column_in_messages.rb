class AddIsReadColumnInMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :is_read, :boolean
  end
end
