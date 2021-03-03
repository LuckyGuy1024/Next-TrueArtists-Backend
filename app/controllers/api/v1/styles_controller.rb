# frozen_string_literal: true

module Api::V1
  class StylesController < ApplicationController
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_style, except: %i[index]

    def index
      @styles = Style.all
      render json: @styles.as_json, status: :ok
    end

    def show
      render json: @style.to_json, status: :ok
    end

    private

    def find_style
      @style = Studio.find(params[:id])
    end

    def style_params
      params.permit(:name)
    end
  end
end
