# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers
  helper EmailHelper
  default from: 'TrueArtists<info@trueartists.com>'
  layout 'mailer'
end
