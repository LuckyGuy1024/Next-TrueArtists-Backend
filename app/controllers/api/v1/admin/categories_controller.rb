module Api
  module V1
    module Admin
      class CategoriesController < BaseController
        before_action :find_category, except: %i[index create]

        def index
          @results = CategorySearch.new(
            query: params[:query],
            options: search_options
          ).filter

          render json: @results, status: :ok
        end

        def show
          render json: CategorySerializer.new(@category).to_json, status: :ok
        end

        def create
          category = Category.new(category_params)

          if category.save
            render json: CategorySerializer.new(category).to_json, status: :created
          else
            render_api_error(status: 422, errors: category.errors)
          end
        end

        def update
          category = BaseForm.new(@category, category_params).update

          if category
            render json: CategorySerializer.new(@category).to_json, status: :ok
          else
            render_api_error(status: 422, errors: @category.errors)
          end
        end

        def destroy
          if @category.destroy
            head(:ok)
          else
            render_api_error(status: 422, errors: @category.errors)
          end
        end

        private

        def find_category
          @category = Category.friendly.find(params[:id])
        end

        def category_params
          params.permit(
            :name,
            :meta_description,
            :description,
            :status
          )
        end

        def search_options
          {
            page: params[:page] || 1,
            per_page: params[:per_page] || BaseSearch::PER_PAGE,
            status: params[:status]
          }.delete_if { |_k, v| v.nil? }
        end
      end
    end
  end
end
