class AddFormattedAddressForUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :formatted_address, :string
  end
end
