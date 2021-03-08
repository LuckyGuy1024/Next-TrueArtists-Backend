class ApplicationMailbox < ActionMailbox::Base
  routing /message\-.+@trueartists.xyz/i => :message
  # routing :all => :message

  def mail_body
    @mail_body ||= begin
      if mail.multipart?
        mail.parts[0].body.decoded
      else
        mail.decoded
      end
    end

    MailExtract.new(@mail_body, only_head: true)
  end
end
