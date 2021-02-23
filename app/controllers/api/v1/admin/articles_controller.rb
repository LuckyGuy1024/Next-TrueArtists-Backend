module Api::V1::Admin
  class ArticlesController < BaseController
    before_action :find_article, except: %i[index create]

    def index
      @results = ArticleSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def show
      render json: ArticleSerializer.new(@article).to_json, status: :ok
    end

    def create
      article = current_user.articles.new(article_params)

      if article.save
        render json: ArticleSerializer.new(article).to_json, status: :created
      else
        render_api_error(status: 422, errors: article.errors)
      end
    end

    def update
      article = BaseForm.new(@article, article_params).update

      if article
        render json: ArticleSerializer.new(@article).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @article.errors)
      end
    end

    def destroy
      if @article.destroy
        head(:ok)
      else
        render_api_error(status: 422, errors: @article.errors)
      end
    end


    private

    def find_article
      @article = Article.friendly.find(params[:id])
    end

    def article_params
      params.permit(:title, :page_title, :meta_description, :introduction, :content, :status, tag_list: [])
    end

    def search_options
      {
        page: params[:page] || 1,
        per_page: params[:per_page] || BaseSearch::PER_PAGE,
        status: params[:status]
      }.delete_if { |_k, v| v.nil? }
    end
  end
end
