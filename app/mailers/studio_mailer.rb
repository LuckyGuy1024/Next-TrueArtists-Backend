class StudioMailer < ApplicationMailer
  # invite artist to studio
  def artist_studio_invite(studio_invite)
    @invite_token = studio_invite.invite_code

    studio_name = studio_invite.studio.name

    subject = format('%s %s %s', 'Invite To Join ', studio_name, ' on TrueArtists')

    mail(to: studio_invite.email, subject: subject)
  end

  def artist_invite_reminder(studio_invite)
    @invite_token = studio_invite.invite_code

    studio_name = studio_invite.studio.name

    subject = format('%s %s %s', 'Reminder: Invite To Join ', studio_name, ' on TrueArtists')

    mail(to: studio_invite.email, subject: subject)
  end

  def confirm_adding_artist(email, studio_name)
    @studio_name = studio_name

    subject = format('%s %s %s', 'Welcome to ', studio_name, ' on TrueArtists')

    mail(to: email, subject: subject)
  end
end
