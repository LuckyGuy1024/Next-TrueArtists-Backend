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
    return nil unless current_user_location
    if current_user_location.state.present?
      "#{current_user_location.city}, #{current_user_location.state}"
    else
      "#{current_user_location.city}, #{current_user_location.country}"
    end
  end

  def current_user_city
    @current_user_city = current_user_location&.city
  end

  def current_user_coordinates
    current_user_location.coordinates
  end

  def current_user_location
    @current_user_location = request.location
  end

  def admin_service_url
    ENV.fetch('ACCOUNT_SERVICE_URL').to_s
  end
  helper_method :admin_service_url

  def account_service_sign_up_url
    "#{ENV.fetch('ACCOUNT_SERVICE_URL')}/register"
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

  def current_canonical_path
    @current_canonical_path ||=
      request.path.gsub(canonical_cleaner_predicate, '')
  end
  helper_method :current_canonical_path

  def current_canonical_url
    @current_canonical_url ||=
      request.url.gsub(canonical_cleaner_predicate, '')
  end
  helper_method :current_canonical_url

  def current_seo_content
    @current_seo_content ||= LandingPage.find_by_page_key(current_canonical_path)
  end
  helper_method :current_seo_content

  private

  def canonical_cleaner_predicate
    %r{(/page/\d+|\?.*|&.*)}
  end

  def user_signed_in?
    current_user.present?
  end

  # Sets the @current_user with the user_id from payload
  def current_user
    @current_user = User.friendly.find_by(id: @current_user_id)
  end

  def fail_if_unauthenticated!; end

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
