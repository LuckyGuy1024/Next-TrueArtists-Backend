class StudioArtist < ApplicationRecord
  require 'json_web_token'
  belongs_to :studio
  belongs_to :artist

  validates :studio_id, :artist_id, presence: true
  validates :artist_id, uniqueness: { scope: :studio_id, message: 'You are already a member of this studio' }
end
