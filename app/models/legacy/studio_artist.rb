# frozen_string_literal: true

module Legacy
  class StudioArtist < Base
    def self.migrate
      connected_to(role: :reading) do
        find_each do |studio_artist|
          new_studio_artist = StudioArtist.find_or_initialize_by(studio_id: studio_artist.studio_id,
                                                                 artist_id: studio_artist.artist_id)

          new_studio_artist.save
        end
      end
    end
  end
end
