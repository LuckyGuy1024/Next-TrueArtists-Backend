class MailerInterceptor
  def self.delivering_email(message)
    intercept_staging(message) if Rails.env.staging?
  end

  def self.intercept_staging(message)
    message.subject.prepend(staging_subject_prefix)
    message.to = filter_recipients(message.to)
  end

  def self.staging_subject_prefix
    'IGNORE, EMAIL FROM STAGING: '
  end

  def self.corporate_domain
    '@trueartists.com'
  end

  def self.filter_recipients(recipients)
    recipients.select { |recipient| recipient.ends_with? corporate_domain }
  end
end
