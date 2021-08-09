class ArtistNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(artist_id)
    artist = Artist.find(artist_id)

    case artist.status
    when 'pending'
      ArtistMailer.complete_profile_reminder(artist).deliver_now
    when 'pending_review'
      # do something
    when 'rejected'
      # do something
    when 'approved'
      # do something
    end
  end
end
