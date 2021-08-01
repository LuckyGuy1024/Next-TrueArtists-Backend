class UserMailer < ApplicationMailer
  def password_reset_instructions(user, token)
    @token = token
    mail(to: user.email, subject: 'Reset your TrueArtists password')
  end

  def new_user_notification(user, password)
    @password = password

    mail(to: user.email, subject: 'New User Notification')
  end
end
