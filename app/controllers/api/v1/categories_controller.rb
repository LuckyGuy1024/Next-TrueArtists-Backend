# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
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

      private

      def find_category
        @category = Category.friendly.find(params[:id])
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
