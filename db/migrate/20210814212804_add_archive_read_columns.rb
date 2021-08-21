class AddArchiveReadColumns < ActiveRecord::Migration[6.1]
  def change
    # add_column :conversations, :archive, :boolean, default: false
    add_column :conversations, :read, :boolean, default: false
  end
end
