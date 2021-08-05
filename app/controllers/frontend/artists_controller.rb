# frozen_string_literal: true

module Frontend
  class ArtistsController < FrontendController
    include ArtistScoped

    def index
      @artists = search.base_filter

      @styles = Style.all

      respond_to do |format|
        format.html
        format.js
      end
    end

    def city
      @city_state = params[:city_state].split('-').join(' ').titleize

      @artists = ArtistSearch.new(
        query: nil,
        options: {
          status: 'approved',
          near: @city_state,
          within: '100mi'
        }
      ).base_filter
    end

    def register
      # @artists = Artist.search(where: { location: { near: { lat: current_user_location.latitude,
      #                                               lon: current_user_location.longitude },
      #                                               within: '100mi' } },
      #                          limit: 6).results
      # @studios = Studio.search(where: { location: { near: { lat: current_user_location.latitude,
      #                                               lon: current_user_location.longitude },
      #                                               within: '100mi' } },
      #                          limit: 6).results

      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      breadcrumbs.add 'Artists', artists_path
      breadcrumbs.add @artist.name

      @tattoos = @artist.tattoos.page(params[:page] || 1).per(BaseSearch::PER_PAGE)

      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
