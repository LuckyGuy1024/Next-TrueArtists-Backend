class Tattoo < ApplicationRecord
  include AASM
  include IdentityCache

  COLORS = ['Color', 'Black & Grey']
  PLACEMENTS = ['Head', 'Neck', 'Shoulder', 'Chest', 'Back',
                'Arm', 'Forearm', 'Ribs', 'Hip', 'Thigh',
                'Lower Leg', 'Foot']

  aasm column: 'status' do
    state :approved, initial: true
    state :flagged

    event :flag do
      transitions from: :approved, to: :flagged
    end
  end

  searchkick locations: [:location]

  include AssetExtension
  acts_as_favoritable
  belongs_to :studio, optional: true
  belongs_to :artist, optional: true

  has_one_attached :image

  validates :image, size: { less_than: 10.megabytes, message: 'is not given between size' }

  before_validation :add_location_data, on: :create
  before_validation :import_tag_list, only: %i[batch_create update]

  def import_tag_list
    self.tag_list = JSON.parse(tag_list).uniq.join(',') if tag_list_changed?
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
