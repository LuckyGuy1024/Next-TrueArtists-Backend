class StudioSearch < BaseSearch
  private def search_class
    Studio
  end

  def filter
    constraints = {
      page: options[:page] || 1,
      per_page: options[:per_page] || PER_PAGE
    }

    constraints[:order] = order

    search_object = if options[:lat] && options[:lon]
                      search_class.search(query, where: {
                                            location: {
                                              near: {
                                                lat: options[:lat],
                                                lon: options[:lon]
                                              },
                                              within: options[:within]
                                            }
                                          })
                    else
                      search_class.search(query, constraints)
                    end

    self.results = search_object.results
    self.meta = pagination_info(search_object)

    {
      studios: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                 serializer: StudioSerializer),
      meta: meta
    }
  end
end
