# frozen_string_literal: true

module Frontend
  class StudiosController < FrontendController
    include StudioScoped

    def index
      breadcrumbs.add 'Studios', studios_path

      @studios  = search.base_filter

      @styles = Style.all

      respond_to do |format|
        format.html
        format.js
      end
    end

    def city
      @city_state = params[:city_state].split('-').join(' ').titleize

      @studios = StudioSearch.new(
        query: nil,
        options: {
          status: 'approved',
          near: @city_state,
          within: '100mi'
        }
      ).base_filter
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
      breadcrumbs.add `#{@studio}`, studio_path

      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
