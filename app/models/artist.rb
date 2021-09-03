# frozen_string_literal: true

require 'open-uri'
class Artist < ApplicationRecord
  include AASM
  include IdentityCache
  serialize :specialty, Array

  SPECIALTY = %w[Flash Freehand].freeze

  searchkick locations: [:location],
             searchable: %i[name slug styles specialty status],
             filterable: %i[specialty styles status]

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
  has_many :bookings, as: :bookable, dependent: :destroy
  has_many :quick_replies, as: :owner, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.format :webp
    attachable.resize '100x100'
  end

  has_one_attached :hero_banner do |attachable|
    attachable.format :webp
  end

  cache_index :slug, unique: true
  cache_index :slug, :status

  validates :user_id, uniqueness: true

  after_commit :send_complete_profile_notification, on: :create
  after_commit :upgrade_user_role, on: :create
  # after_save :send_phone_verification_code, if: :phone_number_changed?
  # after_validation :save_location_data, if: :address_changed?
  before_validation :add_name

  def search_data
    attributes.merge(
      location: { lat: lat, lon: lon },
      styles: styles.map(&:name),
      email: user.email,
      name: user.full_name
    )
  end

  def slug_candidates
    [
      %i[name city state],
      %i[name city state country]
    ]
  end

  def city_state
    # TODO: - fix data
    if state.present? && ['United States', 'US'].include?(country)
      format('%s, %s', city&.titleize, state)
    else
      format('%s, %s', city&.titleize, country)
    end
  end

  def email
    user.email
  end

  def current_studio
    studios.last
  end

  def self.with_status(status)
    where(status: status)
  end

  def search_profile_image
    return avatar if avatar.attached?
    return tattoos.last&.image if tattoos.last&.image&.attached?

    nil
  end

  def has_social_profiles
    instagram_url.present? || facebook_url.present? || twitter_url.present?
  end

  def has_avatar
    avatar.attached?
  end

  def has_styles
    styles.present?
  end

  def has_tattoo_gallery
    tattoos.present?
  end

  def has_phone_number
    phone_number.present?
  end

  def has_address
    city.present? && country.present?
  end

  def notify_admins
    AdminMailer.new_artist_notification(self).deliver_now
  end
  
  def send_phone_verification_code(phone_number)
    phone_number_service = PhoneNumberService.new(phone_number: "+#{phone_number}")
    phone_number_service.verification
    update(phone_number: "+#{phone_number}")
  end

  def verify_phone_number(code)
    phone_number_service = PhoneNumberService.new(code: code, phone_number: phone_number)
    if phone_number_service.verified?
      update(phone_verified: true)
    else
      errors.add(:phone_verified, 'Enter a valid verification code')
      false
    end
  end

  private

  def add_name
    self.name = user.full_name&.titleize
  end

  def upgrade_user_role
    user.assign_role(User.roles[:artist])
  end

  def send_complete_profile_notification
    ArtistNotificationJob.set(wait: 8.hours).perform_later(id)
  end
end
