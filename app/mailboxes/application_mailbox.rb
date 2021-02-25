class ApplicationMailbox < ActionMailbox::Base
  routing /message\-.+@trueartists.com/i => :message
end
