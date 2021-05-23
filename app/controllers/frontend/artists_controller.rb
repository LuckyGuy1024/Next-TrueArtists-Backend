# frozen_string_literal: true

module Frontend
  class ArtistsController < FrontendController
    include ArtistScoped

    def index
      @artists  = search.base_filter

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

    def register
      @artists = Artist.search(where: { location: { near: { lat: 37, lon: -114 },
                                                    within: '500mi' } },
                               limit: 6).results
      @studios = Studio.search(where: { location: { near: { lat: 37, lon: -114 },
                                                    within: '500mi' } },
                               limit: 6)

      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      @tattoos = @artist.tattoos.page(params[:page] || 1).per(BaseSearch::PER_PAGE)

      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
