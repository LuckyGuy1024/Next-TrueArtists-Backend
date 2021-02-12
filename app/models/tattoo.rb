class Tattoo < ApplicationRecord
  include AssetExtension
  belongs_to :studio, optional: true
  belongs_to :artist, optional: true

  has_one_attached :image

  validates :image, size: { less_than: 10.megabytes, message: 'is not given between size' }
end
