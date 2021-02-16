class AddLatLonToArtist < ActiveRecord::Migration[6.0]
  def change
    add_column :artists, :lat, :decimal, precision: 15, scale: 10
    add_column :artists, :lon, :decimal, precision: 15, scale: 10
  end
end
