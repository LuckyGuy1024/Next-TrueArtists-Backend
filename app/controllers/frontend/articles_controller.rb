# frozen_string_literal: true

module Frontend
  class ArticlesController < FrontendController
    include ArticleScoped
    after_action :track_searches, only: [:index]

    def index
      @articles = search.base_filter

      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      @similar_articles = @article.similar(
        where: { status: 'published' },
        fields: %i[tag_list title]
      ).first(12)
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
