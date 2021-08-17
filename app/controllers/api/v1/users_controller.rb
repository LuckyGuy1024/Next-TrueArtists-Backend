# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create]
  before_action :fail_if_unauthenticated!, except: %i[create]
  before_action :find_user, except: %i[create]

  def create
    user = User.new(user_create_params)
    if user.save
      auth_token = JsonWebToken.encode(user_id: user.id)

      render json: {
        user: UserSerializer.new(user),
        auth_token: auth_token
      }, status: :created
    else
      render_api_error(status: 422, errors: user.errors)
    end
  end

  def show
    render json: UserSerializer.new(@user).to_json, status: :ok
  end

  def update
    if @user.update(user_update_params)
      render json: UserSerializer.new(@user).to_json, status: :ok
    else
      render_api_error(status: 422, errors: @user.errors)
    end
  end

  def destroy
    if @user.destroy
      head(:ok)
    else
      render_api_error(status: 422, errors: 'We could not delete resource')
    end
  end

  private

  def find_user
    @user = current_user
  end

  def user_update_params
    params.permit(:email,
                  :full_name,
                  :social_id,
                  :formatted_address,
                  :provider,
                  :password,
                  :password_confirmation)
  end

  def user_create_params
    params.permit(:email,
                  :full_name,
                  :social_id,
                  :provider,
                  :password,
                  :password_confirmation).tap do |whitelisted|
      whitelisted[:password] = whitelisted[:password_confirmation] = SecureRandom.hex(8) if params[:social_id].present?
    end
  end
end
