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
      @city_state = params[:city_state].split('-').join(' ').titleize

      breadcrumbs.add 'Tattoo Shops', studios_path
      breadcrumbs.add @city_state

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
      breadcrumbs.add 'Studios', studios_path
      breadcrumbs.add @studio.name, studio_path(@studio)
      breadcrumbs.add 'Studio Artists'

      @artists = @studio.artists
      respond_to do |format|
        format.html
        format.js
      end
    end

    def tattoos
      breadcrumbs.add 'Studios', studios_path
      breadcrumbs.add @studio.name, studio_path(@studio)
      breadcrumbs.add 'Portfolio'

      @tattoos = @studio.tattoos.page(params[:page]).per(BaseSearch::PER_PAGE)
      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      breadcrumbs.add 'Tattoo Shops', studios_path
      breadcrumbs.add @studio.name

      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
