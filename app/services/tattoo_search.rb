class TattooSearch < BaseSearch
  private def search_class
    Tattoo
  end

  def filter
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      tattoos: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                 serializer: TattooSerializer),
      meta: meta
    }
  end
end
