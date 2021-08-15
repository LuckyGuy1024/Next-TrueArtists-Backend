class MessageMailbox < ApplicationMailbox
  RECIPIENT_FORMAT = /message-(.+)@#{ENV.fetch("INBOUND_EMAIL_DOMAIN", "replies.trueartists.com")}\Z/i.freeze

  before_processing :find_user

  def process
    return unless @user

    # Creating the message
    last_message = Message.where(thread_id: thread_id).order(:created_at).first
    return if last_message.blank?

    receiver_id = if last_message.sender_id == @user.id
                    last_message.receiver_id
                  else
                    last_message.sender_id
                  end

    new_message = Message.new(
      sender_id: @user.id,
      receiver_id: receiver_id,
      conversation_id: last_message.conversation_id,
      subject: mail.subject,
      content: mail_body.body,
      thread_id: thread_id,
      email_client_reply: true
    )

    if new_message.save
      attach_files new_message

      MessageMail.create(
        message_id: new_message.id,
        user_id: @user.id,
        thread_id: thread_id,
        mail_message_id: mail.message_id,
        references: mail.references
      )

      MessageMailingService.new(new_message).forward
    end
  end

  private

  def thread_id
    recipient = mail.recipients.find { |r| RECIPIENT_FORMAT.match?(r) }

    recipient[RECIPIENT_FORMAT, 1]
  end

  def find_user
    @user ||= User.find_by(email: mail.from&.first)
  end

  def attach_files(message)
    if mail.has_attachments?
      mail.attachments.map do |attachment|
        message.attachments.attach(io: StringIO.new(attachment.decoded),
                                   filename: attachment.filename,
                                   content_type: attachment.content_type)
        message.save
      end
    end
  end
end
