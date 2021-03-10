# frozen_string_literal: true

module Api::V1::Admin
  class LocationsController < BaseController
    before_action :find_location, except: %i[create index]

    def index
      @styles = Styles.all
      render json: @styles, status: :ok
    end

    def show
      render json: LocationSerializer.new(@location).to_json, status: :ok
    end

    def create
      location = Location.new(location_params)

      if location.save
        render json: LocationSerializer.new(location).to_json, status: :created
      else
        render_api_error(status: 422, errors: location.errors)
      end
    end

    def update
      location = BaseForm.new(@location, location_params).update

      if location
        render json: LocationSerializer.new(@location).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @location.errors)
      end
    end

    def destroy
      if BaseForm.new(@location).destroy
        head(:ok)
      else
        render_api_error(status: 422, errors: 'We could not delete resource')
      end
    end
    
    private

    def find_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.permit(
        :country,
        :state,
        :city,
        :avatar,
        :hero_banner
      )
    end

    def search_options
      {
        page: params[:page] || 1,
        per_page: params[:per_page] || BaseSearch::PER_PAGE,
        status: params[:status],
        near: params[:near],
        within: params[:within]
      }.delete_if { |_k, v| v.nil? }
    end
  end
end
