class ApplicationMailbox < ActionMailbox::Base
  # routing (/message-.+@replies.trueartists.com/i => :message)
  routing all: :message

  def mail_body
    @mail_body ||= if mail.multipart?
                    mail.text_part.body.decoded
                   else
                     mail.decoded
                   end
    MailExtract.new(@mail_body, only_head: true)
  end
end
