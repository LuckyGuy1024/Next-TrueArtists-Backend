module Frontend
  class TattoosController < FrontendController
    include TattooScoped

    def index
      @tattoos = search.base_filter

      @styles = Style.find_all_cached
      @colors = Tattoo::COLORS
      @placements = Tattoo::PLACEMENTS

      respond_to do |format|
        format.html
        format.js
      end
    end

    def facet
      @styles = Style.find_all_cached
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
  end
end
