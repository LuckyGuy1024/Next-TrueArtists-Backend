class AddIndexTArtistAndStudio < ActiveRecord::Migration[6.0]
  def change
    add_index :studios, :accepting_guest_artist
    add_index :artists, :seeking_guest_spot
    add_index :artists, :guest_artist
  end
end
