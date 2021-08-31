# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper EmailHelper

  default from: 'support@trueartists.com'
  layout 'mailer'
end
