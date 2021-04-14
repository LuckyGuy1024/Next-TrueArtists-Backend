# frozen_string_literal: true

module Frontend
  class ArtistsController < FrontendController
    include ArtistScoped

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

    def city
      @city_state = params[:city_state].split('-').titleize
      @artists = Studio.near(@city_state, 500)
    end

    def show
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
