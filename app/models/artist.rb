# frozen_string_literal: true

class Artist < ApplicationRecord
  include AASM
  include IdentityCache

  SPECIALTY = %w[Flash Freehand].freeze

  searchkick locations: [:location],
             searchable: %i[name slug styles specialty],
             filterable: %i[specialty styles]

  include AddressExtension
  include StatusManagement

  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged finders]

  acts_as_favoritable
  belongs_to :user
  has_many :clients
  has_many :tattoos
  has_many :artist_styles
  has_many :styles, through: :artist_styles
  has_many :studio_artists
  has_many :studios, through: :studio_artists
  has_many :guest_artist_applications
  has_one_attached :avatar
  has_one_attached :hero_banner

  cache_index :slug, unique: true
  # cache_has_many :tattoos, embed: true

  validates :avatar, :hero_banner, size: { less_than: 10.megabytes, message: 'is not given between size' }
  validates :user_id, uniqueness: true

  after_commit :upgrade_user_role, on: :create
  after_save :send_phone_verification_code, if: :phone_number_changed?

  after_validation :save_location_data, if: :address_changed?
  before_validation :add_name

  def search_data
    attributes.merge(
      location: { lat: lat, lon: lon },
      styles: styles.map(&:name)
    )
  end

  def slug_candidates
    [
      %i[name city state],
      %i[name city state country]
    ]
  end

  def city_state
    format('%s %s', city, state)
  end

  def current_studio
    studios.first
  end

  def search_profile_image
    tattoos.first.image
  end

  def has_social_profiles
    instagram_url.present? || facebook_url.present? || twitter_url.present?
  end

  def has_avatar
    avatar.present?
  end

  def has_styles
    styles.present?
  end

  def has_tattoo_gallery
    tattoos.present?
  end

  private

  def add_name
    self.name = user.full_name
  end

  def upgrade_user_role
    user.assign_role(User.roles[:artist])
  end

  def verify_phone(code)
    status = PhoneNumberVerifier.new(code: code, phone_number: phone_number).status

    update(phone_verified: true) if status == 'approved'
  end

  def send_phone_verification_code
    PhoneNumberVerifier.new(phone_number: phone_number).verify
  end
end
