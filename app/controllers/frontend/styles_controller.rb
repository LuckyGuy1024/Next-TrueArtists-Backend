 # frozen_string_literal: true

module Frontend
  class StylesController < FrontendController
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_style, except: %i[index]

    def index
      @styles = Style.all
      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      @search ||= TattooSearch.new(
        query: @style.name,
        options: search_options
      )
      respond_to do |format|
        format.html
        format.js
      end
    end

    def search_options
      {
        page: params[:page] || 1,
        per_page: params[:per_page] || BaseSearch::PER_PAGE
      }.delete_if { |_k, v| v.nil? }
    end

    private

    def find_style
      @style = Style.friendly.find(params[:id])
    end
  end
end
