class MessageMailbox < ApplicationMailbox

  RECIPIENT_FORMAT = /message\-(.+)@trueartists.com/i

  before_processing :find_user

  def process
    return unless @user

    # Creating the message
    # mail.decoded returns the email body if mail is not multipart 
    # else we'll use mail.parts[0].body.decoded
    Message.create(
      user_id: @user.id,
      room_id: message_id,
      subject: mail.subject,
      content: EmailContentExtrator.new(mail).call
    )
  end

  private

  def find_user
    @user ||= User.find_by(email: mail.from)
  end

  def room_id
    recipient = mail.recipients.find { |r| RECIPIENT_FORMAT.match?(r) }
    
    # Returns the first_match and that is message_id
    # For Ex: recipient = "feedback-1234@example.com"
    # Then it'll return 1234
    recipient[RECIPIENT_FORMAT, 1]
  end
end
