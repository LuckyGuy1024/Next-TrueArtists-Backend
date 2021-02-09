
module Api::V1::Admin
  class PasswordsController < AdminController
    def update
      user = User.find(@user_id)

      if user.set_new_password(change_password_params)
        head(:ok)
      else
        render_api_error(status: 422, errors: user.errors)
      end
    end

    private

    def change_password_params
      params.permit(:password, :password_confirmation)
    end
  end
end
