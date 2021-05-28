
class PhoneNumberService
  attr_reader :options

  def initialize(options)
    @message = options[:message]
    @phone_number = options[:phone_number]
    @code = options[:code]
    @client = Twilio::REST::Client.new
  end

  def create_service
    service = @client.verify.services.create(friendly_name: 'Your TrueArtist Verification Code is')

    service.sid
  end

  def verify
    verification = @client.verify.services(create_service).verifications.create(
      to: @phone_number,
      channel: 'sms'
    )

    verification.sid
  end

  def status
    verification_check = @client.verify.services(create_service).verification_checks.create(
      to: @phone_number,
      code: code
    )

    verification_check.status
  end

  def send_sms
    @client.messages.create({
                              from: Rails.application.credentials[:TWILIO_PHONE_NUMBER],
                              to: @phone_number,
                              body: @message
                            })
  rescue Twilio::REST::TwilioError => e
    e.message
  end
end
