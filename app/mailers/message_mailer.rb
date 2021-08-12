class MessageMailer < ApplicationMailer
  MAIL_DOMAIN = '@email.trueartists.com'

  default from: "Message <message#{MAIL_DOMAIN}>"

  def notify(message, mail_references = nil)
    @content = message.content
    @sender = message.sender
    @receiver = message.receiver

    if message.attachments.attached?
      message.attachments.each do |attachment|
        attachments[attachment.filename.to_s] = attachment.download
      end
    end

    mail(
      from: 'TrueArtists<info@trueartists.com>',
      to: @receiver.email,
      reply_to: "#{@sender.full_name} <message-#{message.thread_id}@replies.trueartists.com>",
      subject: "You have a new message from #{@sender.full_name}",
      references: mail_references
    )
  end

  def sender_not_exist(mail_obj)
    mail(
      to: mail_obj.from.first,
      subject: "Re: #{mail_obj.subject}",
      content: 'We do not have an account in our system.'
    )
  end
end
