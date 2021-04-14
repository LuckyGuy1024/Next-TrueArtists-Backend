# frozen_string_literal: true

class Studio < ApplicationRecord
  include AASM

  LANGUAGES = %w[
    Mandarin
    Spanish
    English
    Dutch
    Hindi
    Arabic
    Portuguese
    Russian
    Japanese
    German
    French
    Vietnamese
    Korean
    Italian
    Turkish
  ].freeze

  SERVICES = ['Tattoo Consultation', 'Aftercare Consultation',
              'Basic Body Modification', 'Piercing', 'Scarification',
              'Tattoo Coverup', 'Tattoo Design', 'Tattooing'].freeze

  searchkick word_start: %i[name bio city country services languages], locations: [:location]

  include AddressExtension
  extend FriendlyId
  friendly_id :slug_candidates, use: :history

  include StatusManagement

  acts_as_favoritable
  belongs_to :user
  has_many :studio_invites, dependent: :destroy
  has_many :studio_artists
  has_many :artists, through: :studio_artists
  has_many :tattoos
  has_many :guest_artist_applications
  has_one_attached :avatar
  has_one_attached :hero_banner

  validates :avatar, :hero_banner, size: { less_than: 10.megabytes, message: 'is not given between size' }

  validates :email, presence: true, on: :create
  validates :name, presence: true
  validates :user_id, uniqueness: true

  after_commit :upgrade_user_role, on: :create
  after_validation :save_location_data, if: :address_changed?
  after_save :send_phone_verification_code, if: :phone_number_changed?

  def slug_candidates
    [
      :name,
      %i[name city],
      %i[name city state],
      %i[name city country]
    ]
  end

  def add_artist(artist_id)
    studio_artists.create(artist_id: artist_id)
  end

  def search_data
    attributes.merge(location: { lat: lat, lon: lon })
  end

  def search_profile_image
    tattoos.first&.image || hero_banner
  end

  def city_state
    format('%s %s', city, state)
  end

  def full_address
    format('%s %s %s %s %s', street_address, city, state, country, zip_code)
  end

  def verify_phone(code)
    status = PhoneNumberVerifier.new(code: code, phone_number: phone_number).status

    update(phone_verified: true) if status == 'approved'
  end

  private

  def send_phone_verification_code
    PhoneNumberVerifier.new(phone_number: phone_number).verify
  end

  def upgrade_user_role
    user.assign_role(User.roles[:studio_manager])
  end
end
