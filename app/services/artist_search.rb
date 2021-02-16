class ArtistSearch < BaseSearch
  private def search_class
    Artist
  end

  def filter
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      artists: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                 serializer: ArtistSerializer),
      meta: meta
    }
  end
end
