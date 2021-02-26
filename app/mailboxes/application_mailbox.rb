class ApplicationMailbox < ActionMailbox::Base
  routing /message\-.+@trueartists.xyz/i => :message
  # routing :all => :message
end
