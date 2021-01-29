# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'support@trueartists.com'
  layout 'mailer'
end
