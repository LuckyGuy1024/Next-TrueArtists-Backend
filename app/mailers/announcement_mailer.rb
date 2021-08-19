class AnnouncementMailer < ApplicationMailer
  default from: 'TrueArtists <donotreply@trueartists.com>'

  def send_announcement(announcement, users)
    @announcement = announcement
    subject       = @announcement.title

    personalization = users.map { |email| { to: [{ email: email }] } }

    # sendgrid_recipients users
    # sendgrid_category subject

    mail(
      from: "TrueArtists<#{@announcement.user.email}>",
      reply_to: 'info@trueartists.com',
      personalizations: personalization,
      subject: subject,
      &:html
    )
  end
end
