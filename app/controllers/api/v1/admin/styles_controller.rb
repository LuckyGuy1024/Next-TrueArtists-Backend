# frozen_string_literal: true

module Api::V1::Admin
  class StylesController < BaseController
    before_action :find_style, except: %i[index create]

    def index
      @styles = Style.all
      render json: @styles.as_json, status: :ok
    end

    def show
      render json: @style.to_json, status: :ok
    end

    def create
      style = Style.new(style_params)

      if style.save
        render json: style.to_json, status: :created
      else
        render_api_error(status: 422, errors: style.errors)
      end
    end

    def update
      style = BaseForm.new(@style, style_params).update

      if style
        render json: @style.to_json, status: :ok
      else
        render_api_error(status: 422, errors: @style.errors)
      end
    end

    def destroy
      if @style.destroy
        head(:ok)
      else
        render_api_error(status: 422, errors: @style.errors)
      end
    end

    private

    def find_style
      @style = Style.find(params[:id])
    end

    def style_params
      params.permit(:name, :avatar)
    end
  end
end
