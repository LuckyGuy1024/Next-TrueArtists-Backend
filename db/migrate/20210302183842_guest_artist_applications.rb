class GuestArtistApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :guest_artist_applications do |t|
      t.references :studio
      t.references :artist
      t.string    'phone_number'
      t.string    'message'
      t.string    'duration'
      t.date      'expected_start_date'
      t.boolean   'archive'
      t.datetime  'mark_as_read'
    end
  end
end
