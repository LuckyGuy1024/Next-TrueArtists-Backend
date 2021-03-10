class LocationSearch < BaseSearch
  private def search_class
    Location
  end

  def filter
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      locations: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                   serializer: LocationSerializer),
      meta: meta
    }
  end
end
