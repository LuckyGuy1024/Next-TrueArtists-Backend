class StudioMailer < ApplicationMailer
  # invite artist to studio
  def artist_studio_invite(studio_invite)
    from = Rails.application.credentials.config[:MAIL_NOTIFICATION_FROM]

    email_with_name = %("TrueArtists" <#{from}>)

    mail(to: studio_invite.email, subject: 'Invite To Join TrueArtists')
  end
end
