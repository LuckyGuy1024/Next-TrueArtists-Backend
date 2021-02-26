class MessageMailbox < ApplicationMailbox

  RECIPIENT_FORMAT = /message\-(.+)@trueartists.xyz/i

  before_processing :find_user

  def process
    return unless @user

    # Creating the message
    thread = Message.where(thread_id: thread_id).order(:created_at).first
    return if thread.blank?

    receiver_id = begin
      if thread.sender_id == @user.id
        thread.receiver_id
      else
        thread.sender_id
      end
    end

    new_message = Message.new(
      sender_id: @user.id,
      receiver_id: receiver_id,
      subject: mail.subject,
      content: mail_body.body,
      thread_id: thread_id
    )

    if new_message.save
      # Save mail object
      MessageMail.create(
        message_id:      new_message.id,
        user_id:         @user.id,
        thread_id:       thread_id,
        mail_message_id: mail.message_id,
        references:      mail.references
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
    @user ||= User.find_by(email: mail.from.first)
  end

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
