class MailerInterceptor
  def self.delivering_email(message)
    message.to = ['info@trueartists.com']
  end
end
