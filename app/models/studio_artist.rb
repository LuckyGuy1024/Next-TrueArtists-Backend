class StudioArtist < ApplicationRecord
  require 'json_web_token'
  belongs_to :studio
  belongs_to :artist

  validates :studio_id, :artist_id, presence: true
end
