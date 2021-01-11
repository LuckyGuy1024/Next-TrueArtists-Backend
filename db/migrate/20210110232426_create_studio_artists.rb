class CreateStudioArtists < ActiveRecord::Migration[6.0]
  def change
    create_table :studio_artists do |t|
      t.references :studio
      t.references :artist
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end
end
