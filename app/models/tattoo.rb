class Tattoo < ApplicationRecord
  searchkick word_start: %i[styles placement size color categories tag_list description],
             locations: [:location]

  include AssetExtension
  acts_as_favoritable
  belongs_to :studio, optional: true
  belongs_to :artist, optional: true

  has_one_attached :image

  validates :image, size: { less_than: 10.megabytes, message: 'is not given between size' }

  before_validation :add_location_data, on: :create

  def import_tag_list(tags)
    self.tag_list = tags.uniq.join(',')
  end

  def search_data
    attributes.merge(location: { lat: lat, lon: lon })
  end

  def add_location_data
    if studio
      self.lat = studio.lat
      self.lon = studio.lon
    else
      self.lat = artist.lat
      self.lon = artist.lon
    end
  end
end
