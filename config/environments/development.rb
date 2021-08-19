# frozen_string_literal: true

Rails.application.configure do
  HOST = 'localhost:3001'
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Store files locally.
  config.active_storage.service = :local

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true

  config.action_mailer.default_url_options = { host: 'trueartists.com' }

  # SMTP settings for Sendgrid
  # config.action_mailer.smtp_settings = {
  #   address: 'smtp.sendgrid.net',
  #   port: 587,
  #   enable_starttls_auto: true,
  #   domain: 'trueartists.com',
  #   authentication: :plain,
  #   user_name: 'apikey',
  #   password: ENV.fetch('SENDGRID_APIKEY')
  # }

  # Sendgrid ActionMailer settings for Sendgrid
  config.action_mailer.delivery_method = :sendgrid_actionmailer
  config.action_mailer.sendgrid_actionmailer_settings = {
    api_key: ENV.fetch('SENDGRID_APIKEY'),
    mail_settings: { sandbox_mode: { enable: true }},
    raise_delivery_errors: true
  }

  # Prepare the ingress controller used to receive mail
  config.action_mailbox.ingress = :sendgrid

  # Add ngrok domain to test inbound emails
  config.hosts << ENV.fetch('DOMAIN')

  config.identity_cache_store = :mem_cache_store
  config.action_mailer.default_url_options = { host: HOST }
end
