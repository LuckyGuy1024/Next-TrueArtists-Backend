# frozen_string_literal: true

module AddressExtension
  extend ActiveSupport::Concern
  included do
    geocoded_by :address, latitude: :lat, longitude: :lon
    after_validation :geocode, if: :address_changed?
  end

  def address
    [city, state, country].compact.join(', ')
  end

  def address_changed?
    city_changed? || state_changed? || country_changed?
  end

  def save_location_data
    entity_count = if instance_of?(Studio)
                     :studio_count
                   else
                     :artist_count
                   end

    location = Location.find_or_initialize_by(lat: lat, lon: lon)

    if location.new_record?
      location.country = country
      location.state = state
      location.city = city
      location[entity_count] = 1

      location.save
    else
      location.increment!(entity_count)
    end
  end
end
