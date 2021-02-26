module Api::V1
  class PasswordsController < ApplicationController
    before_action :validate_confirmation_token, only: %i[update]

    def update
      user = User.find(@user_id)

      if user.set_new_password(change_password_params)
        head(:ok)
      else
        render_api_error(status: 422, errors: user.errors)
      end
    end

    def create
      user = User.find_by(email: password_change_request_params[:email])

      if user.reset_password_request
        head(:ok)
      else
        render_api_error(status: 422, errors: 'We could not delete resource')
      end
    end

    private

    def change_password_params
      params.permit(:password, :password_confirmation)
    end

    def password_change_request_params
      params.permit(:email)
    end

    def validate_confirmation_token
      jwt_payload = JsonWebToken.decode(params[:token]).first
      @user_id = jwt_payload['user_id']
      head(:unprocessable_entity) unless @user_id
    end
  end
end
