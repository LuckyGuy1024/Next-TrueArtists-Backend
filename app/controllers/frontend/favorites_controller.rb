# frozen_string_literal: true

module Api::V1
  class FavoritesController < ApplicationController
    before_action :find_favoritable_object

    def create
      current_user.favorite(@favoritable_object)
    end

    def destroy
      current_user.unfavorite(@favoritable_object)
    end

    private

    def favorites_params
      params.permit(:favoritable_type, :favoritable_id)
    end

    def find_favoritable_object
      @favoritable_object = favorites_params[:favoritable_type].constantize.find(favorites_params[:favoritable_id])
    end
  end
end
