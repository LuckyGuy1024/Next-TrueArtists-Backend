# frozen_string_literal: true

module AddressExtension
  extend ActiveSupport::Concern
  included do
    geocoded_by :address do |obj, results|
      if result = results.first
        # obj.street_address = result.street_address
        obj.state = result.state if result.state.present?
        obj.zip_code = result.postal_code if result.postal_code.present?
        obj.city = result.city
        obj.country = result.country
        obj.lat = result.latitude
        obj.lon = result.longitude
      end
    end
    after_validation :geocode #, if: :address_changed?
  end

  def address
    [street_address, city, state, zip_code, country].compact.join(', ')
  end

  def address_changed?
    street_address_changed? || city_changed? || state_changed? || zip_code_changed? || country_changed?
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
