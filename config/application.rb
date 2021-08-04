# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TrueArtists
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.autoload_paths += %W[#{config.root}/lib]

    # Handle Pundit::NotAuthorizedError's by having rails handle them as a 403 error
    config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden
    config.active_storage.web_image_content_types = %w[
      image/jpg
      image/jpeg
      image/gif
      image/png
      image/webp
    ]
  end
end
