class ConventionSearch < BaseSearch
  private def search_class
    Convention
  end

  def filter
    search_results = base_filter
    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      conventions: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                     serializer: ConventionSerializer),
      meta: meta
    }
  end
end
