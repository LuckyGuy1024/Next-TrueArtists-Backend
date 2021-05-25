module Frontend
  class TattoosController < FrontendController
    include TattooScoped
    skip_before_action :authenticate_request!, only: %i[index filter show]
    before_action :find_parent_object, only: %i[batch_create destroy]
    before_action :find_tattoo, except: %i[create index filter batch_create]

    def index
      @tattoos = search.base_filter

      @styles = Style.all
      @colors = Tattoo::COLORS
      @placements = Tattoo::PLACEMENTS

      respond_to do |format|
        format.html
        format.js
      end
    end

    def placement
      
    end

    def show
      @similar_tattoos = @tattoo.similar(fields: [:placement]).first(12)
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
