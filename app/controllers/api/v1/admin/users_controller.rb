# frozen_string_literal: true

module Api::V1::Admin
  class UsersController < BaseController
    before_action :find_user, except: %i[index create]

    def index
      @results = UserSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def create
      user = User.new(user_create_params)
      if user.save
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
      @user = User.friendly.find(params[:id])
    end

    def user_update_params
      params.require(:user).permit(:email, :role, :status)
    end

    def search_options
      {
        role: params[:role],
        status: params[:status],
        page: params[:page] || 1
      }.delete_if { |_k, v| v.nil? }
    end

    def user_create_params
      params.permit(:email,
                    :full_name,
                    :role,
                    :status,
                    :role).tap do |whitelisted|
        whitelisted[:password] = whitelisted[:password_confirmation] = SecureRandom.hex(6)
      end
    end
  end
end
