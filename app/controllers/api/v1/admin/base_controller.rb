class Api::V1::Admin::BaseController < ApplicationController
  before_action :check_user_role

  private

  def check_user_role
    return if current_user.admin?
    render json: {
      errors: 'You\'re not authorised to access this page.'
    }, status: :unauthorized
  end
end
