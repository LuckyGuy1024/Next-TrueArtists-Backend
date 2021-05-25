# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ConventionsController < BaseController
        before_action :find_convention, except: %i[index create]

        def index
          @results = ConventionSearch.new(
            query: params[:query],
            options: search_options
          ).filter

          render json: @results, status: :ok
        end

        def show
          render json: ConventionSerializer.new(@convention).to_json, status: :ok
        end

        def create
          convention = current_user.conventions.new(convention_params)

          if convention.save
            render json: ConventionSerializer.new(convention).to_json, status: :created
          else
            render_api_error(status: 422, errors: convention.errors)
          end
        end

        def update
          convention = BaseForm.new(@convention, convention_params).update

          if convention
            render json: ConventionSerializer.new(@convention).to_json, status: :ok
          else
            render_api_error(status: 422, errors: @convention.errors)
          end
        end

        def destroy
          if @convention.destroy
            head(:ok)
          else
            render_api_error(status: 422, errors: @convention.errors)
          end
        end

        private

        def find_convention
          @convention = Convention.friendly.find(params[:id])
        end

        def convention_params
          params.permit(
            :name,
            :address,
            :city,
            :state,
            :country,
            :link_to_official_site,
            :facebook_link,
            :start_date,
            :end_date,
            :image
          )
        end

        def search_options
          {
            page: params[:page] || 1,
            per_page: params[:per_page] || BaseSearch::PER_PAGE,
            status: params[:status],
            near: params[:city] || params[:near],
            within: params[:within],
            user_role: current_user.role
          }.delete_if { |_k, v| v.nil? }
        end
      end
    end
  end
end
