class GuestArtistApplication < ApplicationRecord
  belongs_to :studio
  belongs_to :artist
  has_one :guest_artist_application_response, dependent: :destroy
  validates :phone_number, :duration, :expected_start_date, :message, presence: true
  validates_uniqueness_of :studio_id, scope: :artist_id, message: 'invite to studio sent already'
end
