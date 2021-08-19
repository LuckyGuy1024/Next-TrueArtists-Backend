class UserMailer < ApplicationMailer
  def password_reset_instructions(user, token)
    @token = token
    mail(to: user.email, subject: 'Reset your TrueArtists password')
  end

  def change_password_request(user, token)
    @token = token
    mail(to: user.email, subject: 'We have created an account for you at TrueArtists')
  end

  def notify_on_password_update(user)
    @user = user
    mail(to: user.email, subject: 'Password Update')
  end
end
