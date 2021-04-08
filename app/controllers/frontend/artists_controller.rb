# frozen_string_literal: true

module Frontend
  class ArtistsController < FrontendController
    include ArtistsScoped

    def index
      @results = search
    end

    def show
      render json: ArtistSerializer.new(@artist).to_json, status: :ok
    end
  end
end
