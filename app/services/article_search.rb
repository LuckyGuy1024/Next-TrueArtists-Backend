class ArticleSearch < BaseSearch
  private def search_class
    Article
  end

  def filter
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      articles: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                  serializer: ArticleSerializer),
      meta: meta
    }
  end
end
