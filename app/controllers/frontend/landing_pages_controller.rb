# frozen_string_literal: true

module Frontend
  class LandingPagesController < FrontendController
    include LandingPageScoped
    
    def home
      @artists = ArtistSearch.new(
        query: nil,
        options: {
          status: 'approved',
          page: 1,
          per_page: 8,
          near: [current_user_location.latitude, current_user_location.longitude],
          within: '100mi'
        }
      ).base_filter

      @studios = StudioSearch.new(
        query: nil,
        options: {
          status: 'approved',
          page: 1,
          per_page: 8,
          near: [current_user_location.latitude, current_user_location.longitude],
          within: '100mi'
        }
      ).base_filter

      @styles = Style.all
      @tattoo_placements = Tattoo::PLACEMENTS

      respond_to do |format|
        format.html.mobile
        format.html.none
        format.js
      end
    end

    def about_us
      respond_to do |format|
        format.html
        format.js
      end
    end

    def privacy
      respond_to do |format|
        format.html
        format.js
      end
    end

    def terms
      respond_to do |format|
        format.html
        format.js
      end
    end

    def contact_us
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
