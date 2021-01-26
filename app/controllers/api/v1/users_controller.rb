# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create]
  before_action :fail_if_unauthenticated!, except: %i[create]
  before_action :find_user, except: %i[create]

  def create
    user = User.new(user_create_params)
    if user.save
      auth_token = JsonWebToken.encode(user_id: user.id)
      render json: UserSerializer.new(user, root: false).to_json,
             message: 'User created successfully',
             status: 201
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
    @user = User.find(params[:id])
  end

  def user_update_params
    params.require(:user).permit(:email)
  end

  def user_create_params
    params.permit(:email,
                  :role,
                  :name,
                  :status,
                  :password,
                  :password_confirmation)
  end
end
