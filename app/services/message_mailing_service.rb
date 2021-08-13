class MessageMailingService
  def initialize(message)
    @message = message
  end

  # Send a message created on the system to a recipient
  def send
    mail = MessageMailer.notify(@message).deliver
    save_message_mail(mail)
  end

  # Forward inbound message to recipient
  def forward
    mail = MessageMailer.notify(@message, latest_references).deliver
    save_message_mail(mail)
  end

  private

  def save_message_mail(mail)
    MessageMail.create(
      message_id: @message.id,
      thread_id: @message.thread_id,
      user_id: @message.receiver_id,
      mail_message_id: mail.message_id,
      references: mail.references.try(:join, ',')
    )
  end

  def latest_references
    last_mail = MessageMail.where(thread_id: @message.thread_id,
                                  user_id: @message.receiver_id)
                           .order(:created_at)
                           .last
    return nil unless last_mail && last_mail.references

    last_mail.references.split(',')
             .push(last_mail.message_id)
             .map { |r| "<#{r}>" }
             .join(' ')
  end
end
