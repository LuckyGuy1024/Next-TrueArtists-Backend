# frozen_string_literal: true

module Api
  module V1
    class ConventionsController < ApplicationController
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
        @convention = Convention.verified_conventions.upcoming_conventions.friendly.find(params[:id])
      end

      def search_options
        {
          page: params[:page] || 1,
          per_page: params[:per_page] || BaseSearch::PER_PAGE,
          status: params[:status],
          near: params[:city] || params[:near],
          verified: true,
          time_constraint: Date.today,
          within: params[:within],
          user_role: current_user.role
        }.delete_if { |_k, v| v.nil? }
      end
    end
  end
end
