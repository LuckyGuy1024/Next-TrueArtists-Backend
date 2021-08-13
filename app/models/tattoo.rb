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
    state :pending_review, initial: true
    state :approved
    state :flagged
    state :rejected

    event :flag, after_commit: :send_tattoo_status_notification do
      transitions from: :approved, to: :flagged
    end

    event :reject do
      transitions from: [:pending_review, :approved], to: :rejected
    end

    event :approve do
      transitions from: [:pending_review, :flagged, :rejected], to: :approved
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

  cache_index :slug, unique: true
  cache_index :slug, :status

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

  def send_tattoo_status_notification
    TattooMailer.send_tattoo_status_notification(self).deliver_now
  end
end
