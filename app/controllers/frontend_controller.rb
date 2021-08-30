# frozen_string_literal: true

class FrontendController < ActionController::Base
  protect_from_forgery prepend: true

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

  def lazy_image_tag(target_src, **attrs, &block)
    (attrs ||= {}).symbolize_keys!

    target_src = image_path(target_src) unless target_src =~ %r{http(s)?://} || target_src.nil?

    (attrs[:data] ||= {})[:src] = target_src
    empty_string = ''.dup
    lazyload_css = ' lazyload'.dup
    attrs[:class] = (attrs[:class] || empty_string) << lazyload_css
    attrs.reverse_merge!(src: 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==')

    ActionController::Base.helpers.content_tag(:img, **attrs) do
      capture(&block) if block_given?
    end
  end
  helper_method :lazy_image_tag

  private

  def canonical_cleaner_predicate
    %r{(/page/\d+|\?.*|&.*)}
  end

  def user_signed_in?
    current_user.present?
  end

  # Sets the @current_user with the user_id from payload
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def fail_if_unauthenticated!; end

  # Validates the token and user and sets the @current_user scope
  def authenticate_request!; end

  def set_request_variant
    request.variant = :mobile if browser.mobile? || browser.tablet?
  end

  def modern_browser?
    [
      browser.chrome?('>= 65'),
      browser.safari?('>= 10'),
      browser.firefox?('>= 52'),
      browser.ie?('>= 11') && !browser.compatibility_view?,
      browser.edge?('>= 15'),
      browser.opera?('>= 50'),
      browser.facebook? && browser.safari_webapp_mode? && browser.webkit_full_version.to_i >= 602
    ].any?
  end
  helper_method :modern_browser?

  def set_layout
    if Array(request.variant).include? :mobile
      'mobile'
    else
      'application'
    end
  end

  def track_searches
    return unless params[:query]

    Searchjoy::Search.create(
      search_type: controller_name,
      query: params[:query],
      user_id: current_user&.id
    )
  end
end
