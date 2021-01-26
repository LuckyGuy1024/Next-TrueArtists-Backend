class AddArtistIdStudioIdToTattoos < ActiveRecord::Migration[6.0]
  def change
    add_column :tattoos, :artist_id, :integer
    add_column :tattoos, :studio_id, :integer
  end
end
