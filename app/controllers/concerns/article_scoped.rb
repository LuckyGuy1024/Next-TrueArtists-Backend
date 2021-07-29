# frozen_string_literal: true

module ArticleScoped
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_article, except: %i[index]
  end

  private

  def search
    @search = ArticleSearch.new(
      query: params[:query],
      options: search_options
    )
  end

  def search_options
    {
      page: params[:page] || 1,
      per_page: params[:per_page] || BaseSearch::PER_PAGE,
      status: params[:status]
    }.delete_if { |_k, v| v.nil? }
  end

  def find_article
    @article = Article.friendly.find(params[:id])
  end
end
