# frozen_string_literal: true

class FrontendController < ActionController::Base
  layout :set_layout

  before_action :authenticate_request!
  before_action :set_request_variant

  helper_method :current_user_location,
                :current_user_city,
                :current_user_city_state,
                :current_user_coordinates

  def current_user_city_state
    if current_user_location.country_code == 'US'
      "#{current_user_location.city}, #{current_user.state}"
    else
      "#{current_user_location.city}, #{current_user.country}"
    end
  end

  def current_user_city
    @current_user_city = current_user_location.city
  end

  def current_user_coordinates
    current_user_location.coordinates
  end

  def current_user_location
    @current_user_location = request.location
  end

  def account_service_sign_up_url
    "#{ENV.fetch('ACCOUNT_SERVICE_URL')}/login"
  end
  helper_method :account_service_sign_up_url

  def account_service_login_url
    "#{ENV.fetch('ACCOUNT_SERVICE_URL')}/login"
  end
  helper_method :account_service_login_url

  def account_service_user_profile_url
    "#{ENV.fetch('ACCOUNT_SERVICE_URL')}/dashboard"
  end
  helper_method :account_service_user_profile_url


  def account_service_artist_signup_url
    "#{ENV.fetch('ACCOUNT_SERVICE_URL')}/register-selection"
  end
  helper_method :account_service_artist_signup_url

  def about_us_url
    "#{ENV.fetch('ACCOUNT_SERVICE_URL')}/about-us"
  end
  helper_method :about_us_url

  def contact_us_url
    "#{ENV.fetch('ACCOUNT_SERVICE_URL')}/contact-us"
  end
  helper_method :contact_us_url

  private

  # Validates the token and user and sets the @current_user scope
  def authenticate_request!; end

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
