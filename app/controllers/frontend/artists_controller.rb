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
      @studios = Studio.near(@city_state, 100)
    end

    def register
      @artists = Artist.search(where: { location: { near: { lat: current_user_location.latitude,
                                                    lon: current_user_location.longitude },
                                                    within: '100mi' } },
                               limit: 6).results
      @studios = Studio.search(where: { location: { near: { lat: current_user_location.latitude,
                                                    lon: current_user_location.longitude },
                                                    within: '100mi' } },
                               limit: 6).results

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
