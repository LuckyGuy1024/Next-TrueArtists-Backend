module Frontend
  class TattoosController < FrontendController
    include TattooScoped

    before_action :find_styles, only: %i[index styles facet]
    before_action :find_placements, only: %i[index placements facet]

    def index
      breadcrumbs.add 'Tattoos', tattoos_path

      @tattoos = search.base_filter

      @colors = Tattoo::COLORS

      respond_to do |format|
        format.html
        format.js
      end
    end

    def placements
      respond_to do |format|
        format.html
        format.js
      end
    end

    def styles
      breadcrumbs.add 'Tattoo Styles', styles_path

      respond_to do |format|
        format.html
        format.js
      end
    end

    def facet
      @name = (params[:placement] || params[:style]).split('-').join(' ').titleize
      @tattoos = TattooSearch.new(query: @name).base_filter
      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
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
