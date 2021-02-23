class Api::V1::ArticlesController < ApplicationController
  before_action :find_article, except: %i[index]

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

  private

  def find_article
    @article = Article.friendly.find(params[:id])
  end

  def search_options
    {
      page: params[:page] || 1,
      per_page: params[:per_page] || BaseSearch::PER_PAGE,
      status: params[:status]
    }.delete_if { |_k, v| v.nil? }
  end
end
