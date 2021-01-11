class StudioArtist < ApplicationRecord
  belongs_to :studio
  belongs_to :artist
end
