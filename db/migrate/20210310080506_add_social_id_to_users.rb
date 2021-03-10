class AddSocialIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :social_id, :string
    add_index :users, :social_id
  end
end
