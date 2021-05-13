# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Pundit
  require 'json_web_token'

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found!

  before_action :authenticate_request!

  # Validates the token and user and sets the @current_user scope
  def authenticate_request!
    if request.headers['Authorization'].present?
      authenticate_or_request_with_http_token do |token|
        jwt_payload = JsonWebToken.decode(token).first
        @current_user_id = jwt_payload['user_id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        render json: {
          errors: 'You\'re not authorised to access this resource.'
        }, status: :unauthorized
      end
    end
  end

  def user_signed_in?
    current_user.present?
  end

  # Sets the @current_user with the user_id from payload
  def current_user
    @current_user = User.friendly.find_by(id: @current_user_id)
  end

  def current_address
    # TODO: implement
  end

  def fail_if_unauthenticated!
    unless user_signed_in?
      render json: {
        errors: 'Unauthorised. Sign in to access this resource.'
      }, status: :unauthorized
    end
  end

  def render_not_found!
    render_api_error(status: 404, errors: 'Resource not found')
  end

  def render_api_error(status: 500, errors: [])
    head(status: status) && return if errors.empty?

    render(json: json_api_error_format(errors).to_json, status: status) && return if errors.respond_to?(:messages)

    render json: { errors: errors }.to_json, status: status
  end

  def paginate(resource)
    resource = resource.page(params[:page] || 1)
    resource.per(params[:per_page] || 25)
  end

  def pagination_info(resource)
    {
      current_page: resource.current_page,
      total_pages: resource.total_pages,
      last_page?: resource.last_page?,
      next_page: resource.next_page || resource.current_page
    }
  end
  
  private

  def json_api_error_format(errors)
    return errors if errors.is_a? String

    errors.messages.each_with_object({}) do |(attribute, error), res|
      res[attribute] =
        error.each_with_object([]) do |e, attrs|
          attrs << { attribute: attribute, message: e }
        end
    end
  end

  def user_not_authorized
    render json: { errors: 'You are not authorized to perform this action.' }, status: :unauthorized
  end
end
