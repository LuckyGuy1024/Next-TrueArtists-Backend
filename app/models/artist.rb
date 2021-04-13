# frozen_string_literal: true

class Artist < ApplicationRecord
  include AASM
  SPECIALTY = %w[Flash Freehand].freeze

  searchkick word_start: %i[bio slug website facebook_url twitter_url instagram_url city country specialty services],
             locations: [:location]

  include AddressExtension
  include StatusManagement

  extend FriendlyId
  friendly_id :slug_candidates, use: :history

  acts_as_favoritable
  belongs_to :user
  has_many :tattoos
  has_many :artist_styles
  has_many :styles, through: :artist_styles
  has_many :studio_artists
  has_many :studios, through: :studio_artists
  has_many :guest_artist_applications
  has_one_attached :avatar
  has_one_attached :hero_banner

  validates :avatar, :hero_banner, size: { less_than: 10.megabytes, message: 'is not given between size' }
  validates :user_id, uniqueness: true

  after_commit :upgrade_user_role, on: :create
  after_save :send_phone_verification_code, if: :phone_number_changed?

  after_validation :save_location_data, if: :address_changed?
  before_validation :add_name

  def search_data
    attributes.merge(location: { lat: lat, lon: lon })
  end

  def slug_candidates
    [
      :name,
      %i[name city],
      %i[name city state],
      %i[name city country]
    ]
  end

  def city_state
    format('%s %s', city, state)
  end

  def search_profile_image
    tattoos.first.image
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
