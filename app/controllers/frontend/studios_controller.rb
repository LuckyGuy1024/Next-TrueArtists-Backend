# frozen_string_literal: true

module Frontend
  class StudiosController < FrontendController
    include StudioScoped

    def index
      @studios  = search.base_filter

      @styles = Style.all

      respond_to do |format|
        format.html
        format.js
      end
    end

    def city
      @city_state = params[:city_state]
      @studios = Studio.near(@city_state, 500).page
    end

    def artists
      @artists = @studio.artists
      respond_to do |format|
        format.html
        format.js
      end
    end

    def tattoos
      @tattoos = @studio.tattoos.page(params[:page]).per(BaseSearch::PER_PAGE)
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
  end
end
