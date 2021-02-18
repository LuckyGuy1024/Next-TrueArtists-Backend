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

    private

    def find_tattoo
      @tattoo = Tattoo.find(params[:id])
    end

    def tattoo_params
      params.permit(*permitted_attributes)
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
