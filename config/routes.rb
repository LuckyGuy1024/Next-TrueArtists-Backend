load "#{Rails.root}/config/routes/api.rb"
load "#{Rails.root}/config/routes/admin.rb"
load "#{Rails.root}/config/routes/frontend.rb"

Rails.application.routes.draw do
  direct :asset_blob do |blob|
    # Preserve the behaviour of `rails_blob_url` inside these environments
    # where S3 or the CDN might not be configured
    if Rails.env.development? || Rails.env.test?
      route_for(:rails_blob, blob)
    else
      # Use an environment variable instead of hard-coding the CDN host
      # You could also use the Rails.configuration to achieve the same
      File.join(ENV.fetch('CDN_HOST'), blob.key)
    end
  end
end
