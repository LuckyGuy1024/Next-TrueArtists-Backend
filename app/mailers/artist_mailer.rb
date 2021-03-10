class ArtistMailer < ApplicationMailer
  def notify_on_account_status(email, status)
    @status = status

    subject = format('Account Status')

    mail(to: email, subject: subject)
  end
end
