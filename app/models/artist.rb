# frozen_string_literal: true

class Artist < ApplicationRecord
  searchkick word_start: %i[bio slug website facebook_url twitter_url instagram_url city country specialty services],
             locations: [:location]

  include AssetExtension
  acts_as_favoritable
  belongs_to :user
  has_many :tattoos
  has_many :studio_artists
  has_many :studios, through: :studio_artists
  has_one_attached :avatar
  has_one_attached :hero_banner

  validates :avatar, :hero_banner, size: { less_than: 10.megabytes, message: 'is not given between size' }
  validates :user_id, uniqueness: true

  after_commit :upgrade_user_role, on: :create

  geocoded_by :address, latitude: :lat, longitude: :lon
  after_validation :geocode, if: :address_changed?
  after_save :send_phone_verification_code, if: :phone_number_changed?


  def search_data
    attributes.merge(location: { lat: lat, lon: lon })
  end

  def address
    [city, country].compact.join(', ')
  end

  def address_changed?
    city_changed? || country_changed?
  end

  def upgrade_user_role
    user.assign_role(User.roles[:artist])
  end

  def verify_phone(code)
    status = PhoneNumberVerifier.new(code: code, phone_number: phone_number).status

    update(phone_verified: true) if status == 'approved'
  end

  private

  def send_phone_verification_code
    PhoneNumberVerifier.new(phone_number: phone_number).verify
  end
end
