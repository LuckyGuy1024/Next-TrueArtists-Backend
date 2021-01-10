# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create]

  def create
    user = User.find_by(email: user_login_params[:email])

    if user&.authenticate(user_login_params[:password])
      auth_token = JsonWebToken.encode(user_id: user.id)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: { errors: 'Invalid email / password' }, status: :unauthorized
    end
  end

  ## TODO: Refactor to handle logout with token blacklisting
  def destroy; end

  private

  def user_login_params
    params.require(:user).permit(:email, :password)
  end
end
