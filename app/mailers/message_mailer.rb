class MessageMailer < ApplicationMailer

  MAIL_DOMAIN = '@trueartists.xyz'

  default from: "Message <message#{MAIL_DOMAIN}>"

  def notify(message, mail_references = nil)
    @content = message.content
    @sender = message.sender
    @receiver = message.receiver

    mail(
      from: "#{@sender.full_name} <message@trueartists.xyz>",
      to: @receiver.email,
      reply_to: "#{@sender.full_name} <message-#{message.thread_id}@trueartists.xyz>",
      subject: message.subject,
      references: mail_references
    )
  end

  def sender_not_exist(mail_obj)
    mail(
      to: mail_obj.from.first,
      subject: "Re: #{mail_obj.subject}",
      content: "You don't exist on our system."
    )
  end
end
