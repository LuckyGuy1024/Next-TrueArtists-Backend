# frozen_string_literal: true

Twilio.configure do |config|
  config.account_sid = Rails.application.credentials[:TWILIO_ACCOUNT_SID]
  config.auth_token = Rails.application.credentials[:TWILIO_AUTH_TOKEN]
end
