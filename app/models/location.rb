# frozen_string_literal: true

class Location < ApplicationRecord
  searchkick locations: [:location]

  include AddressExtension
  has_one_attached :avatar
  has_one_attached :hero_banner

  validates :avatar, :hero_banner, size: { less_than: 10.megabytes, message: 'is not given between size' }

  def search_data
    attributes.merge(location: { lat: lat, lon: lon })
  end
end
