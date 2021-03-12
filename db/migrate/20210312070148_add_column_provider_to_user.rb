class AddColumnProviderToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :provider, :string
    add_index :users, :provider
  end
end
