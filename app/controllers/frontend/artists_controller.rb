
# frozen_string_literal: true

module Frontend
  class ArtistsController < FrontendController
    include ArtistsScoped

    def index
      search_results = search.base_filter

      @artists = search_results.results
      @meta = search.pagination_info(search_results)

      @styles = Style.all

      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      render json: ArtistSerializer.new(@artist).to_json, status: :ok
    end
  end
end
