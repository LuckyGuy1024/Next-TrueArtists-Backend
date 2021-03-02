class LandingPageSearch < BaseSearch
  private def search_class
    LandingPage
  end

  def filter
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      tattoos: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                 serializer: LandingPageSerializer),
      meta: meta
    }
  end
end
