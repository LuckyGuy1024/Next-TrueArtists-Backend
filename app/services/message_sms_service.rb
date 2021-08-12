# frozen_string_literal: true

class MessageSmsService
  def initialize(message, phone_number)
    @message = message
    @phone_number = phone_number
  end

  # Send a sms created on the system to a recipient
  def send
    @message = generate_message_url

    PhoneNumberService.new(message: @message, phone_number: @phone_number).send_sms
  end

  private

  def generate_message_url
    "#{ENV.fetch('HOST')}/api/v1/messages?thread_id=#{@message.thread_id}"
  end
end
