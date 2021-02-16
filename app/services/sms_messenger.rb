
class SmsMessenger
  attr_reader :message, :phone_number

  def initialize(message, phone_number)
    @message = message
    @phone_number = phone_number
  end

  def call
    client = Twilio::REST::Client.new

    client.messages.create({
                             from: Rails.application.credentials[:TWILIO_PHONE_NUMBER],
                             to: phone_number,
                             body: message
                           })
  end
end
