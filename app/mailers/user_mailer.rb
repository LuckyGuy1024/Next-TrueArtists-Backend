class UserMailer < ApplicationMailer
  def password_reset_instructions(user, token)
    @token = token
    mail(to: user.email, subject: 'Reset your TrueArtists password')
  end
end
