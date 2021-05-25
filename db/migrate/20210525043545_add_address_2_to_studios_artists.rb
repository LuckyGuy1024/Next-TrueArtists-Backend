class AddAddress2ToStudiosArtists < ActiveRecord::Migration[6.0]
  def change
    add_column :studios, :street_address_2, :string
    add_column :artists, :street_address_2, :string
  end
end
