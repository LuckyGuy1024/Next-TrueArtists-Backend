# frozen_string_literal: true

module Frontend
  class LandingPagesController < FrontendController
    include LandingPageScoped

    def index
      @landing_pages = search.base_filter

      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      respond_to do |format|
        format.html
        format.js
      end
    end

    def home
      @artists = Artist.first(12)
      @studios = Studio.first(12)
      @styles = Style.all.map(&:name)
      @placement = Tattoo::PLACEMENTS
      respond_to do |format|
        format.html.mobile
        format.html.none
        format.js
      end
    end
  end
end
