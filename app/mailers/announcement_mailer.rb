class AnnouncementMailer < ApplicationMailer
  default from: 'TrueArtists <donotreply@trueartists.com>'

  def send_announcement(announcement, users)
    @announcement = announcement
    subject       = @announcement.title

    personalization = users.map { |email| { to: [{ email: email }] } }

    mail(
      to: "TrueArtists <#{@announcement.user.email}>",
      from: "TrueArtists <#{@announcement.user.email}>",
      reply_to: 'info@trueartists.com',
      personalizations: personalization,
      subject: subject,
      &:html
    )
  end
end
