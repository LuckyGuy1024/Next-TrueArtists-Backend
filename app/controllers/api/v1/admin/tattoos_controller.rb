module Api::V1::Admin
  class TattoosController < BaseController
    before_action :find_tattoo, except: %i[index]

    def index
      @results = TattooSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def show
      render json: TattooSerializer.new(@tattoo).to_json, status: :ok
    end

    def update
      if @tattoo.update(tattoo_params)
        render json: TattooSerializer.new(@tattoo).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @tattoo.errors)
      end
    end

    def flag
      @tattoo.flag!
      render json: TattooSerializer.new(@tattoo.reload).to_json, status: :ok
    rescue AASM::InvalidTransition => e
      render_api_error(status: 422, errors: e.message)
    end

    def approve
      @tattoo.approve!
      render json: TattooSerializer.new(@tattoo.reload).to_json, status: :ok
    rescue AASM::InvalidTransition => e
      render_api_error(status: 422, errors: e.message)
    end

    private

    def find_tattoo
      @tattoo = Tattoo.find(params[:id])
    end

    def tattoo_params
      params.permit(*permitted_attributes)
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

    def permitted_attributes
      %i[
        studio_id
        artist_id
        styles
        categories
        placement
        color
        size
        image
        tags
      ]
    end
  end
end
