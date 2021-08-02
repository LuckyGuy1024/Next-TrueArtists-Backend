class AdminMailer < ApplicationMailer
  def new_artist_notification(artist)
    @artist = artist
    admin_email = 'info@trueartists.com'
    mail(to: admin_email, subject: 'New Artist Notification')
  end

  def new_studio_notification(studio)
    @studio = studio
    admin_email = 'info@trueartists.com'
    mail(to: admin_email, subject: 'New Studio Notification')
  end
end
