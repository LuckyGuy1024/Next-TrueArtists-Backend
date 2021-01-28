class StudioMailer < ApplicationMailer
  # invite artist to studio
  def artist_studio_invite(studio_invite)
    mail(to: studio_invite.email, subject: 'Invite To Join TrueArtists')
  end
end
