class Studio < ApplicationRecord
  has_many :studio_artists
  has_many :artists, through: :studio_artists
end
