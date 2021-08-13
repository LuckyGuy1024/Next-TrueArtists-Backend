module Frontend
  class TattoosController < FrontendController
    include TattooScoped

    before_action :find_styles, only: %i[index styles facet]
    before_action :find_placements, only: %i[index placements facet]

    def index
      @tattoos = search.base_filter

      @colors = Tattoo::COLORS

      respond_to do |format|
        format.html
        format.js
      end
    end

    def placements
      breadcrumbs.add 'Tattoos', tattoos_path
      breadcrumbs.add 'By Placement'

      respond_to do |format|
        format.html
        format.js
      end
    end

    def styles
      breadcrumbs.add 'Tattoos', tattoos_path
      breadcrumbs.add 'Styles'

      respond_to do |format|
        format.html
        format.js
      end
    end

    def facet
      @name = (params[:placement] || params[:style]).split('-').join(' ').titleize

      breadcrumbs.add 'Tattoos', tattoos_path
      if params[:placement]
        breadcrumbs.add 'Placements', placements_tattoos_path
      else
        breadcrumbs.add 'Styles', styles_tattoos_path
      end
      breadcrumbs.add @name

      @tattoos = TattooSearch.new(query: @name).base_filter
      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      breadcrumbs.add 'Tattoos', tattoos_path

      @similar_tattoos = @tattoo.similar(
        fields: %i[
          placement styles
          colors categories caption description
        ]
      ).first(12)

      respond_to do |format|
        format.html
        format.js
      end
    end

    private

    def find_styles
      @styles = Style.find_all_cached
    end

    def find_placements
      @placements = Placement.find_all_cached
    end
  end
end
