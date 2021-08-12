class BookingSearch < BaseSearch
  private def search_class
    Booking
  end

  def filter
    search_results = base_filter
    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      bookings: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                 serializer: BookingSerializer),
      meta: meta
    }
  end
end
