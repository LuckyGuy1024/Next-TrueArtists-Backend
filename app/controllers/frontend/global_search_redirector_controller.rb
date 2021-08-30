module Frontend
  class GlobalSearchRedirectorController < FrontendController
    skip_before_action :authenticate_request!, only: %i[index]
    before_action :validate_search_path
    after_action :track_searches, only: [:index]

    def index
      redirect_to url_for(controller: params[:search_path].to_s,
                          action: 'index',
                          near: params[:near],
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

  def track_searches
    Searchjoy::Search.create(
      search_type: "GlobalSearch-#{params{:search_path}}",
      query: params[:query],
      user_id: current_user&.id
    )
  end
end
