class ArtistNotificationJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # TO-DO: Find a better way to handle errors
    Rails.logger.error exception
  end

  def perform(artist_id)
    subject = {
      0 => 'First Reminder',
      1 => 'Second Reminder',
      2 => 'Third Reminder',
      3 => 'Last Reminder'
    }

    artist = Artist.find(artist_id)

    return if artist.reminder_count > 3

    case artist.status
    when 'pending'
      ArtistMailer.complete_profile_reminder(artist, subject[artist.reminder_count]).deliver_now
    when 'pending_review'
      # do something
    when 'rejected'
      # do something
    when 'approved'
      # do something
    end

    # update reminder count
    artist.update(reminder_count: artist.reminder_count + 1)
  end
end
