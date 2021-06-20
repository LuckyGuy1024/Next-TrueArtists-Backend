class AnnouncementMailer < ApplicationMailer
  default from: 'TrueArtists <donotreply@trueartists.com>'

  def send_announcement(announcement, users)
    @announcement = announcement
    subject       = @announcement.title

    # sendgrid_recipients users
    # sendgrid_category subject

    mail(to: 'donotreply@trueartists.com',
         from: "TrueArtists<#{@announcement.user.email}>",
         reply_to: 'info@trueartists.com',
         subject: subject) do |format|
      format.html
    end
  end
end
