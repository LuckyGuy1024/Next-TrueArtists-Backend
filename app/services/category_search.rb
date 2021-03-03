class CategorySearch < BaseSearch
  private def search_class
    Category
  end

  def filter
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      categories: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                  serializer: CategorySerializer),
      meta: meta
    }
  end
end
