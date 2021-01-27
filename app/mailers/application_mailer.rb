# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.config[:MAIL_NOTIFICATION_FROM]
  layout 'mailer'
end
