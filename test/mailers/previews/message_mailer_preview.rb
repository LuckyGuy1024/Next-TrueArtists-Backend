# Preview all emails at http://localhost:3000/rails/mailers/message_mailer
class MessageMailerPreview < ActionMailer::Preview
  def notify
    MessageMailer.with(message: Message.find(1)).notify.deliver
  end
end
