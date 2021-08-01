class AdminMailer < ApplicationMailer
  def new_artist_notification(artist)
    @artist = artist
    admin_email = 'info@trueartists.com'
    mail(to: admin_email, subject: 'Reset your TrueArtists password')
  end
end
