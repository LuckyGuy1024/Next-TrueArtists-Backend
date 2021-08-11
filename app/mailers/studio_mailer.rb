class StudioMailer < ApplicationMailer
  # invite artist to studio
  def artist_studio_invite(studio_invite)
    @invite_token = studio_invite.invite_code

    studio_name = studio_invite.studio.name

    subject = format('%s %s %s', 'Invite To Join ', studio_name, ' on TrueArtists')

    mail(to: studio_invite.email, subject: subject)
  end

  # invite new artist to studio
  def new_artist_studio_invite(studio_invite)
    @invite_token = studio_invite.invite_code

    @studio_name = studio_invite.studio.name

    subject = format('%s %s %s', 'Invite To Join ', @studio_name, ' on TrueArtists')

    mail(to: studio_invite.email, subject: subject)
  end

  def artist_invite_reminder(studio_invite)
    @invite_token = studio_invite.invite_code

    studio_name = studio_invite.studio.name

    subject = format('%s %s %s', 'Reminder: Invite To Join ', studio_name, ' on TrueArtists')

    mail(to: studio_invite.email, subject: subject)
  end

  def new_artist_invite_reminder(studio_invite)
    @invite_token = studio_invite.invite_code

    @studio_name = studio_invite.studio.name

    subject = format('%s %s %s', 'Reminder: Invite To Join ', @studio_name, ' on TrueArtists')

    mail(to: studio_invite.email, subject: subject)
  end

  def confirm_adding_artist(email, studio_name)
    @studio_name = studio_name

    subject = format('%s %s %s', 'Welcome to ', studio_name, ' on TrueArtists')

    mail(to: email, subject: subject)
  end

  def cancel_studio_invite(email, studio_name)
    @studio_name = studio_name

    subject = format('%s %s %s', 'Welcome to ', studio_name, ' on TrueArtists')

    mail(to: email, subject: subject)
  end

  def notify_on_account_status(email, status)
    @status = status

    subject = format('Account Status')

    mail(to: email, subject: subject)
  end

  def notify_on_account_rejection(email)
    subject = format('TrueArtists Account Status Update')

    mail(to: email, subject: subject)
  end

  def notify_guest_artist(message, email)
    @message = message

    subject = format('Guest Artist Response')

    mail(to: email, subject: subject)
  end

  def new_studio_notification(studio)
    @studio = studio
    mail(to: studio.email, subject: 'New Studio Notification')
  end

  def complete_profile_reminder(studio, reminder_count)
    @studio = studio
    mail(to: studio.email, subject: "#{reminder_count}: Complete Your Studio Profile")
  end

  def upload_new_images(studio)
    @studio = studio
    mail(to: studio.email, subject: 'Reminder: Upload New Tattoo Images')
  end
end
