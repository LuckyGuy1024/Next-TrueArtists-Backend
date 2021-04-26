# frozen_string_literal: true

module Frontend
  class ArticlesController < FrontendController
    include ArticleScoped

    def index
      @articles = search.base_filter

      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      @similar_articles = @article.similar(fields: [:tag_list]).first(12)
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
