
module Api::V1::Admin
  class PasswordsController < BaseController
    before_action :find_user, only: %i[create]

    def create
      if @user.reset_password_request
        head(:ok)
      else
        render_api_error(status: 422, errors: 'Request could not be made.')
      end
    end

    private

    def find_user
      @user = User.find_by(email: change_password_request[:email])
      head(:not_found) unless @user
    end

    def change_password_request
      params.permit(:email)
    end
  end
end
