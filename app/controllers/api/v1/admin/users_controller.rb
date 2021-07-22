# frozen_string_literal: true

module Api::V1::Admin
  class UsersController < BaseController
    before_action :find_user, except: %i[index create]

    def index
      @users = if params[:query]
                 User.where('email LIKE :query OR full_name LIKE :query', query: "%#{params[:query]}%")
               else
                 User
                        end.where(search_filter.except(:page)).page(params[:page])
      render json: { users: ActiveModel::Serializer::CollectionSerializer.new(@users,
                                                                              serializer: UserSerializer),
                     meta: {
                       current_page: @users.current_page,
                       total_pages: @users.total_pages,
                       last_page: @users.last_page?,
                       next_page: @users.next_page || resource.current_page,
                       limit_value: @users.limit_value,
                       total_count: @users.total_count
                     } },
             status: :ok
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

    def search_filter
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
        whitelisted[:password] = whitelisted[:password_confirmation] = Devise.friendly_token.first(8)
      end
    end
  end
end
