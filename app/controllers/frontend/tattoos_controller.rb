module Frontend
  class TattoosController < FrontendController
    include TattooScoped
    skip_before_action :authenticate_request!, only: %i[index filter show]
    before_action :find_parent_object, only: %i[batch_create destroy]
    before_action :find_tattoo, except: %i[create index filter batch_create]

    def index
      search_results = search.base_filter

      @tattoos = search_results.results
      @meta = search.pagination_info(search_results)

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
