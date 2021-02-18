class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string   'country'
      t.string   'state'
      t.string   'city'
      t.integer   'studio_count'
      t.integer   'artist_count'
      t.decimal  'lat',                  precision: 15, scale: 10
      t.decimal  'lon',                  precision: 15, scale: 10
    end
  end
end
