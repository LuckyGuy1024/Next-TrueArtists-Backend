class BaseSearch
  PER_PAGE = 60
  attr_reader :query, :options
  attr_accessor :results, :meta

  def initialize(query: nil, options: {})
    @query = query.presence || '*'
    @options = options
  end

  def base_filter
    location_info = {}

    constraints = {
      page: options[:page] || 1,
      per_page: options[:per_page] || PER_PAGE
    }

    constraints[:order] = order

    constraints[:where] = {
      specialty: options[:specialty],
      styles: options[:styles],
      placement: options[:placement],
      status: options[:status],
      studio_id: options[:studio_id],
      artist_id: options[:artist_id]
    }.delete_if { |_k, v| v.nil? }

    location_info = if options[:near] && coordinates.present?
                      { order: {
                        _geo_distance: {
                          location: coordinates,
                          order: 'asc'
                        }
                      },
                        where: { location: { near: coordinates, within: options[:within] } } }
                    else
                      { order: {
                          _geo_distance: {
                            location: options[:current_user_coordinates],
                            order: 'asc'
                          }
                        }
                      }
                    end

    constraints.merge(location_info)

    search_class.search(query, constraints)
  end

  def coordinates
    location = Geocoder.search(options[:near]).first

    return nil unless location

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
      order = options[:sort_order].presence || :asc
      { options[:sort_attribute] => order }
    else
      {}
    end
  end
end
