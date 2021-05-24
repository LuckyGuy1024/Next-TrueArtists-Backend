# frozen_string_literal: true

module Frontend
  class PagesController < FrontendController
    before_action :find_page, except: %i[index create]
    def index
      @results = PageSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def show
      render json: PageSerializer.new(@page).to_json, status: :ok
    end

    private

    def find_page
      @page = Page.friendly.find(params[:id])
    end
  end
end
