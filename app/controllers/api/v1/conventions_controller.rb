# frozen_string_literal: true

module Api
  module V1
    class ConventionsController < ApplicationController
      skip_before_action :authenticate_request!, only: %i[index show]
      before_action :find_convention, except: %i[index]

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

      private

      def find_convention
        @convention = Convention.friendly.find(params[:id])
      end

      def search_options
        {
          page: params[:page] || 1,
          per_page: params[:per_page] || BaseSearch::PER_PAGE,
          status: params[:status],
          near: params[:city] || params[:near],
          time_constraint: Date.today,
          within: params[:within]
        }.delete_if { |_k, v| v.nil? }
      end
    end
  end
end
