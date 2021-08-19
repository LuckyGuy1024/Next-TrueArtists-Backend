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

  def base_filter
    includes = {}

    constraints = {
      page: options[:page] || 1,
      per_page: options[:per_page] || PER_PAGE
    }

    constraints[:order] = order

    constraints[:includes] = options[:includes] if options[:includes].present?

    constraints[:where] = {
      email: options[:email],
      phone_number: options[:phone_number],
      status: options[:status]
    }.merge(owner_options).delete_if { |_k, v| v.nil? }

    search_class.search(query, **constraints)
  end

  def owner_options
    @owner = options[:user]
    return {} if @owner.blank?

    if @owner.artist
      return {
        bookable_id: @owner.artist.id,
        bookable_type: @owner.artist.class.to_s
      }
    end

    if @owner.studio
      return {
        bookable_id: @owner.studio.id,
        bookable_type: @owner.studio.class.to_s
      }
    end

    {
      user_id: @owner.id
    }
  end
end
