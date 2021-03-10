class AddAddressToArtist < ActiveRecord::Migration[6.0]
  def change
    add_column :artists, :street_address, :string
  end
end
