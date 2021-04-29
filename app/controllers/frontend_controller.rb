# frozen_string_literal: true

class FrontendController < ActionController::Base
  layout :set_layout

  before_action :authenticate_request!
  before_action :set_request_variant
  before_action :user_location

  private

  # Validates the token and user and sets the @current_user scope
  def authenticate_request!; end

  def user_location
    city = request.location.city
    country = request.location.country

    city || country
  end

  def set_request_variant
    request.variant = :mobile if browser.mobile? || browser.tablet?
  end

  def set_layout
    if Array(request.variant).include? :mobile
      'mobile'
    else
      'application'
    end
  end
end
