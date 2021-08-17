ActionMailer::Base.register_interceptor(MailerInterceptor) if Rails.env.staging?
