module Api::V1
  class PasswordsController < ApplicationController
    skip_before_action :authenticate_request!, only: %i[create update]
    before_action :find_user, only: %i[create]

    def update
      @user = User.find_by_password_reset_token(params[:token])

      if @user && @user.set_new_password(change_password_params)
        @user.notify_on_password_update

        head(:ok)
      else
        render_api_error(status: 422, errors: ['Password reset link has expired. Reset your password again'])
      end
    end

    def create
      if @user.reset_password_request
        head(:ok)
      else
        render_api_error(status: 422, errors: ['Invalid request. Reset your password again'])
      end
    end

    private

    def find_user
      @user = User.find_by(email: password_change_request_params[:email])
      head(:not_found) unless @user
    end

    def change_password_params
      params.permit(:password, :password_confirmation)
    end

    def password_change_request_params
      params.permit(:email)
    end
  end
end
