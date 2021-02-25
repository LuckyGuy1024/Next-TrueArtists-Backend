class MessageMailer < ActionMailer::Base
  default from: 'message@trueartists.com'

  def landing_email(opts)
    @body = opts[:body]
    mail(
      to: opts[:to],
      subject: opts[:subject],
      body: opts[:body],
      content_type: "text/html"
    )
  end

  def landing_email_reply(opts)
    @body = opts[:body]
    mail(
      to: opts[:to],
      subject: opts[:subject],
      body: opts[:body],
      references: opts[:message_id],
      content_type: "text/html"
    )
  end
end
