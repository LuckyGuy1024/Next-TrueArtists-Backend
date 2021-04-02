# frozen_string_literal: true

module Api::V1
  class LocationsController < ApplicationController
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_location, only: %i[show]

    def index
      @results = LocationSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def show
      render json: LocationSerializer.new(@location).to_json, status: :ok
    end

    private

    def find_location
      @location = Location.find(params[:id])
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
