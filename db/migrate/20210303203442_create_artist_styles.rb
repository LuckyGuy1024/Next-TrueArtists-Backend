class CreateArtistStyles < ActiveRecord::Migration[6.0]
  def change
    create_table :artist_styles do |t|
      t.references :artist
      t.references :style
      t.timestamps
    end
  end
end
