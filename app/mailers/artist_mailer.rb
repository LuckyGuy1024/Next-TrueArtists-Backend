class ArtistMailer < ApplicationMailer
  def notify_on_account_status(email, status)
    @status = status

    subject = format('Account Status')

    mail(to: email, subject: subject)
  end

  def new_artist_notification(artist)
    @artist = artist
    mail(to: artist.user.email, subject: 'New Artist Notification')
  end

  def complete_profile_reminder(artist)
    @artist = artist
    mail(to: artist.user.email, subject: 'Reminder: Complete Your Artist Profile')
  end

  def upload_new_images(artist)
    @artist = artist
    mail(to: artist.user.email, subject: 'Reminder: Upload New Tattoo Images')
  end
end
