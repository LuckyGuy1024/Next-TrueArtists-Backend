# frozen_string_literal: true

class Studio < ApplicationRecord
  searchkick word_start: %i[name bio city country specialty services], locations: [:location]

  include AssetExtension
  acts_as_favoritable
  belongs_to :user
  has_many :studio_invites, dependent: :destroy
  has_many :studio_artists
  has_many :artists, through: :studio_artists
  has_many :tattoos
  has_one_attached :avatar
  has_one_attached :hero_banner

  validates :avatar, :hero_banner, size: { less_than: 10.megabytes, message: 'is not given between size' }

  validates :email, presence: true, on: create
  validates :user_id, uniqueness: true

  after_commit :upgrade_user_role, on: :create

  geocoded_by :address, latitude: :lat, longitude: :lon
  after_validation :geocode, if: :address_changed?


  def search_data
    attributes.merge(location: { lat: lat, lon: lon })
  end

  def address
    [street_address, city, state, country].compact.join(', ')
  end

  def address_changed?
    street_address_changed? || city_changed? || state_changed? || country_changed?
  end

  def add_artist(artist_id)
    studio_artists.create(artist_id: artist_id)
  end

  private

  def upgrade_user_role
    user.assign_role(User.roles[:studio_manager])
  end
end
