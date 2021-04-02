# frozen_string_literal: true

module Api::V1
  class LandingPagesController < ApplicationController
    before_action :find_landing_page, except: %i[create index]

    def index
      @results = LandingPageSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def show
      render json: LandingPageSerializer.new(@landing_page).to_json, status: :ok
    end

    private

    def find_landing_page
      @landing_page = LandingPage.find(params[:id])
    end

    def search_options
      {
        page: params[:page] || 1,
        per_page: params[:per_page] || BaseSearch::PER_PAGE,
        status: params[:status],
      }.delete_if { |_k, v| v.nil? }
    end
  end
end
