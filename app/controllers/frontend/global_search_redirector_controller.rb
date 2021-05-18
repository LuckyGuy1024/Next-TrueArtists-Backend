module Frontend
  class GlobalSearchRedirectorController < FrontendController
    skip_before_action :authenticate_request!, only: %i[index]
    before_action :validate_search_path

    def index
      binding.pry
      redirect_to url_for(controller: "frontend#{params[:search_path]}",
                          action: 'index',
                          query: params[:query])
    end

    private

    def validate_search_path
      return unless %w[
        tattoos
        artists
        studios
        articles
      ].include?(params[:search_path])
    end
  end
end
