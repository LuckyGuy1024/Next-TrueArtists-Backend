# frozen_string_literal: true

class GuestArtistApplicationSerializer < ActiveModel::Serializer
  has_one :guest_artist_application_response
  attributes :id,
             :studio_id,
             :artist_id,
             :phone_number,
             :message,
             :duration,
             :expected_start_date,
             :mark_as_read,
             :archive
end
