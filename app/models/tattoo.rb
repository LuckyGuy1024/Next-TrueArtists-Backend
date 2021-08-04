class Tattoo < ApplicationRecord
  include AASM
  include IdentityCache
  include AssetExtension
  extend FriendlyId

  acts_as_favoritable

  COLORS = ['Color', 'Black & Grey'].freeze
  PLACEMENTS = ['Head', 'Neck', 'Shoulder', 'Chest', 'Back',
                'Arm', 'Forearm', 'Ribs', 'Hip', 'Thigh',
                'Lower Leg', 'Foot'].freeze

  aasm column: 'status' do
    state :approved, initial: true
    state :flagged

    event :flag do
      transitions from: :approved, to: :flagged
    end

    event :approve do
      transitions from: :flagged, to: :approved
    end
  end

  friendly_id :slug_candidates, use: %i[slugged finders]

  searchkick locations: [:location]

  belongs_to :studio, optional: true
  belongs_to :artist, optional: true
  belongs_to :style, optional: true

  has_one_attached :image do |attachable|
    attachable.format :webp
  end

  validates :image, size: { less_than: 10.megabytes, message: 'is not given between size' }

  before_validation :add_location_data, on: :create
  before_validation :import_tag_list, only: %i[batch_create update]

  def import_tag_list
    self.tag_list = JSON.parse(tag_list).uniq.join(',') if tag_list_changed?
  end

  def search_data
    attributes.merge(location: { lat: lat, lon: lon }, style: style&.name)
  end

  def seo_title
    format('%s %s %s %s | %s', style&.name, color, placement, 'Tattoo', (artist.name || studio.name)).titleize
  end

  def slug_candidates
    [
      %i[id style_slug placement]
    ]
  end

  def style_slug
    style&.slug
  end

  def add_location_data
    parent = artist || studio
    if parent.present?
      self.lat = parent.lat
      self.lon = parent.lon
    end
  end

  def parent
    artist || studio
  end
end
