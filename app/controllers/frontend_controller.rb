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
