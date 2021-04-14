# frozen_string_literal: true

# frozen_string_literal: true

module Frontend
  class StudiosController < FrontendController
    include StudioScoped

    def index
      search_results = search.base_filter

      @studios = search_results.results
      @meta = search.pagination_info(search_results)

      # @styles = Style.all

      respond_to do |format|
        format.html
        format.js
      end
    end

    def city
      @studios = Studio.near(params[:city], 500)
    end

    def artists
      @tattoos = @studio.artists.page(BaseSearch::PER_PAGE).per(params[:page])
      respond_to do |format|
        format.html
        format.js
      end
    end

    def tattoos
      @tattoos = @studio.tattoos.page(BaseSearch::PER_PAGE).per(params[:page])
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
