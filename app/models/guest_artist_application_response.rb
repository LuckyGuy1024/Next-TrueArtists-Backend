class GuestArtistApplicationResponse < ApplicationRecord
  belongs_to :guest_artist_application
  belongs_to :user

  validates_presence_of :message
  validates :guest_artist_application_id, uniqueness: { scope: :user_id, message: 'response made already already' }
  after_commit :notify_guest_artist

  private

  def notify_guest_artist
    email = guest_artist_application.artist.user.email
    StudioMailer.notify_guest_artist(message, email).deliver_now
  end
end
