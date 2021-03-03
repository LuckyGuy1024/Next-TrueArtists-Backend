class CreateGuestArtistApplicationResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :guest_artist_application_responses do |t|
      t.references :guest_artist_application, index: false, foreign_key: true
      t.references       :user
      t.text             :message
      t.index [:guest_artist_application_id], name: 'index_application_responses_on_application'
    end
  end
end
