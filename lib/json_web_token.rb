# frozen_string_literal: true

require 'jwt'

class JsonWebToken
  # Encodes and signs JWT Payload with expiration
  def self.encode(payload)
    payload.reverse_merge!(meta)
      JWT.encode(payload, ENV.fetch('SECRET_KEY_BASE'))
  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    JWT.decode(token, ENV.fetch('SECRET_KEY_BASE'))
  end

  # Validates the payload hash for expiration and meta claims
  def self.valid_payload(payload)
    if expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
      false
    else
      true
    end
  end

  # Default options to be encoded in the token
  def self.meta
    {
      exp: 12.hours.from_now.to_i,
      iss: 'issuer_name',
      aud: 'client'
    }
  end

  # Validates if the token is expired by exp parameter
  def self.expired(payload)
    Time.at(payload['exp']) < Time.now
  end
end
