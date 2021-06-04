# frozen_string_literal: true

class Convention < ApplicationRecord
  include AASM
  searchkick word_start: %i[name verified], locations: [:location]

  extend FriendlyId
  friendly_id :name, use: :history

  aasm column: 'verified' do
    state :pending, initial: true
    state :pending_review
    state :approved
    state :rejected

    event :pending_review do
      transitions from: :pending, to: :pending_review
    end

    event :approve do
      transitions from: %i[pending_review pending], to: :approved
    end

    event :reject do
      transitions from: %i[pending_review pending], to: :rejected
    end
  end

  has_one_attached :image

  validates :image, size: { less_than: 10.megabytes, message: 'is not given between size' }

  belongs_to :user, class_name: 'User', foreign_key: :created_by

  validates :name, :start_date, :end_date, :address, :city, :state, :country, :link_to_official_site, presence: true

  geocoded_by :convention_address, latitude: :lat, longitude: :lon
  after_validation :geocode, if: :convention_address_changed?

  ## Scope ##
  scope :verified_conventions, -> { where('verified = ?', "true") }
  scope :upcoming_conventions, -> { where('start_date > ?', Date.today).order('start_date') }

  def search_data
    attributes.merge(location: { lat: lat, lon: lon })
  end

  def convention_address
    [address, city, state, country].compact.join(', ')
  end

  def convention_address_changed?
    address_changed? || city_changed? || state_changed? || country_changed?
  end

  ## Instance Methods ##
  def starts_at
    start_date.strftime('%H:%M %p')
  end

  def should_generate_new_friendly_id?
    new_record? || slug.blank?
  end

  def ends_at
    end_date.strftime('%H:%M %p')
  end

  def print_schedule
    start_date.strftime('On %B %d ') + end_date.strftime(' to %B %d ')
  end

  def full_address
    [address, city, state, Carmen::Country.coded(country)].to_sentence(last_word_connector: ' in ')
  end
end
