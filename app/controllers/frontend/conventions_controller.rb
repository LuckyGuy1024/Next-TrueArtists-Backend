# frozen_string_literal: true

module Frontend
  class ConventionsController < FrontendController
    include ConventionScoped

    def index
      @conventions = search.base_filter

      respond_to do |format|
        format.html
        format.js
      end
    end

    def city
      @city_state = params[:city_state]
      @conventions = Convention.near(@city_state, 500)
    end

    def show
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
