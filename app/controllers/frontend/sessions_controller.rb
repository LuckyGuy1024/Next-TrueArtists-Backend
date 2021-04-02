# frozen_string_literal: true

class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create]
  before_action :find_user

  def create
    if social_authentication || password_authentication
      auth_token = JsonWebToken.encode(user_id: @user.id)

      render json: {
        user: UserSerializer.new(@user, root: false),
        auth_token: auth_token
      }, status: :ok
    else
      render json: { errors: 'Invalid email / password' }, status: :unauthorized
    end
  end

  ## TODO: Refactor to handle logout with token blacklisting
  def destroy; end

  private

  def password_authentication
    true if session_params[:password] && @user&.authenticate(session_params[:password])
  end

  def social_authentication
    true if social_params[:social_id] && @user
  end

  def find_user
    @user = User.find_by(email: session_params[:email]) ||
            User.find_by(social_id: social_params[:social_id])
  end

  def session_params
    params.require(:user).permit(:email, :password)
  end

  def social_params
    params.require(:user).permit(:social_id, :provider)
  end
end
