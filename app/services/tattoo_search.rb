class TattooSearch < BaseSearch
  private def search_class
    Tattoo
  end

  def search_tattoos
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      tattoos: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                 serializer: TattooSerializer),
      meta: meta
    }
  end

  def filter
    search_results = search_class.search(
      boost_by_distance: {
        location: {
          origin: location_data
        }
      },
      where: {
        location: {
          near: location_data,
          within: options[:within]
        }
      }.merge(filter_options)
    )

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      tattoos: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                 serializer: TattooSerializer),
      meta: meta
    }
  end

  private

  def location_data
    location = Location.find(query)

    return nil unless location.lat || location.lon

    {
      lat: location.lat,
      lon: location.lon
    }
  end

  def filter_options
    {
      studio_id: options[:studio_id],
      artist_id: options[:artist_id],
      placement: build_filter_params(options[:placement]),
      styles: build_filter_params(options[:styles]),
      color: build_filter_params(options[:color])
    }.delete_if { |_k, v| v.nil? }
  end

  def build_filter_params(params)
    if params.nil?
      nil
    else
      params.split('%2C')
    end
  end
end
