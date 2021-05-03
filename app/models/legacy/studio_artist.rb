# frozen_string_literal: true
module Legacy
  class StudioArtist < Base
    self.abstract_class = true
    self.table_name = "studio_artists"
    connects_to database: { reading: :legacy, writing: :primary }

    def self.migrate
      ActiveRecord::Base.connected_to(role: :reading) do
        progress_bar = ProgressBar.new(Legacy::StudioArtist.count)
        find_each do |studio_artist|
          ActiveRecord::Base.connected_to(role: :writing) do
            new_studio_artist = ::StudioArtist.find_or_initialize_by(studio_id: studio_artist.studio_id,
                                                                     artist_id: studio_artist.artist_id)

            new_studio_artist.save
            progress_bar.increment
          end
        end
      end
    end
  end
end
