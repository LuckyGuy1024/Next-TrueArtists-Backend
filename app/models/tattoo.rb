class Tattoo < ApplicationRecord
  include AssetExtension
  belongs_to :studio
  belongs_to :artist
  has_one_attached :image

  validates :image, attached: true, size: { less_than: 10.megabytes, message: 'is not given between size' }
end
