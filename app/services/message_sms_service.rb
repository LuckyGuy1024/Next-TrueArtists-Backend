# frozen_string_literal: true

class MessageSmsService < BaseMessageService

  # Send a sms created on the system to a recipient
  def send
    @message = generate_message_url

    # find user phone number
    @phone_number = @message.receiver

    PhoneNumberService.new(message: @message, phone_number: @phone_number).send_sms
  end

  private

  def generate_message_url
    "#{ENV.fetch('HOST')}/api/v1/messages?thread_id=#{thread_id}"
  end
end
