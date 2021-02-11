class StudioSearch < BaseSearch
  private def search_class
    Studio
  end

  def filter
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      studios: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                 serializer: StudioSerializer),
      meta: meta
    }
  end
end
