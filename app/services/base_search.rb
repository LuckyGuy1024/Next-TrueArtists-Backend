class BaseSearch
  PER_PAGE = 60
  attr_reader :query, :options
  attr_accessor :results, :meta

  def initialize(query: nil, options: {})
    @query = query.presence || '*'
    @options = options
  end

  def filter
    constraints = {
      page: options[:page] || 1,
      per_page: options[:per_page] || PER_PAGE
    }

    constraints[:order] = order

    if options[:lat]
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
    end

    self.results ||= search_object.results
    self.meta = pagination_info(search_object)
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
