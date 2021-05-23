# frozen_string_literal: true

module Frontend
  class LandingPagesController < FrontendController
    include LandingPageScoped
    before_action :find_landing_page, except: %i[home index about_us contact_us]

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

    def about_us
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
