class PhoneNumberService
  attr_reader :message, :phone_number, :code

  def initialize(options = {})
    @message = options[:message]
    @phone_number = options[:phone_number]
    @code = options[:code]
  end

  def verification
    client.verify
          .services(ENV.fetch('TWILIO_VERIFICATION_SID'))
          .verifications
          .create(
            to: phone_number,
            channel: 'sms'
          )
  end

  def verified?
    client.verify
          .services(ENV.fetch('TWILIO_VERIFICATION_SID'))
          .verification_checks
          .create(
            to: phone_number,
            code: code
          ).status == 'approved'
  rescue Twilio::REST::RestError => e
    false
  end

  def send_sms
    client.messages.create({
                             from: ENV.fetch('TWILIO_PHONE_NUMBER'),
                             to: phone_number,
                             body: message
                           })
  rescue Twilio::REST::TwilioError => e
    e.message
  end

  private

  def client
    @client = Twilio::REST::Client.new
  end
end
