 # frozen_string_literal: true

module Frontend
  class StylesController < FrontendController
    before_action :find_style, except: %i[index]
    before_action :find_all_styles, only: %i[index show]

    def index
      breadcrumbs.add 'Styles', styles_path

      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      breadcrumbs.add @style.name, style_path

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

    def find_all_styles
      @styles = Style.find_all_cached
    end

    def find_style
      @style = Style.friendly.find(params[:id])
    end
  end
end
