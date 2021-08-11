# frozen_string_literal: true

module Frontend
  class SessionsController < FrontendController
    def destroy
      session[:user_id] = nil
      redirect_to account_service_login_url
    end
  end
end
