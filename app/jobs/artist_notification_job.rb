class ArtistNotificationJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
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

    reminder = Reminder.find_or_create_by(user_id: artist.user.id)

    return if reminder.complete_profile > 3

    case artist.status
    when 'pending'
      ArtistMailer.complete_profile_reminder(artist, subject[reminder.complete_profile]).deliver_now
    when 'pending_review'
      # do something
    when 'rejected'
      # do something
    when 'approved'
      # do something
    end

    # update reminder count
    reminder.update(complete_profile: reminder.complete_profile + 1) if reminder.complete_profile < 4
  end
end
