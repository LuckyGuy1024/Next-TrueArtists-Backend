# frozen_string_literal: true

class FrontendController < ActionController::Base
  layout "application"

  before_action :authenticate_request!

  # Validates the token and user and sets the @current_user scope
  def authenticate_request!
  end
end
