class BaseSearch
  PER_PAGE = 60
  WITHIN = '100mi'
  attr_reader :query, :options
  attr_accessor :results, :meta

  def initialize(query: nil, options: {})
    @query = query.presence || '*'
    @options = options
  end

  def base_filter
    includes = {}
    location_info = {}

    constraints = {
      page: options[:page] || 1,
      per_page: options[:per_page] || PER_PAGE
    }

    within = options[:within] || WITHIN

    constraints[:order] = order

    constraints[:includes] = options[:includes] if options[:includes].present?

    constraints[:where] = {
      specialty: options[:specialty],
      styles: options[:styles],
      placement: options[:placement],
      status: options[:status],
      studio_id: options[:studio_id],
      artist_id: options[:artist_id]
    }.delete_if { |_k, v| v.nil? }

    coordinates = find_coordinates

    location_info = if options[:near] && coordinates.present?
                      { order: {
                        _geo_distance: {
                          location: { lat: coordinates[:lat], lon: coordinates[:lon] },
                          order: 'asc'
                        }
                      },
                        where: { location: { near: { lat: coordinates[:lat], lon: coordinates[:lon] },
                                             within: within } } }
                    elsif coordinates.present?
                      { order: {
                        _geo_distance: {
                          location: {
                            lat: coordinates[:lat], lon: coordinates[:lon]
                          },
                          order: 'asc'
                        }
                      } }
                    else
                      {}
                    end

    constraints = constraints.deep_merge(location_info)

    search_class.search(query, **constraints)
  end

  def find_coordinates
    location = Geocoder.search(options[:near]).first || options[:current_user_location]

    return nil unless location&.latitude.present? && location&.longitude.present?

    {
      lat: location.latitude,
      lon: location.longitude
    }
  end

  def pagination_info(resource)
    {
      current_page: resource.current_page,
      total_pages: resource.total_pages,
      last_page: resource.last_page?,
      next_page: resource.next_page || resource.current_page,
      limit_value: resource.limit_value,
      total_count: resource.total_count
    }
  end

  private

  def order
    if options[:sort_attribute].present?
      order = options[:sort_order].presence || :desc
      { options[:sort_attribute] => order }
    else
      {}
    end
  end
end
