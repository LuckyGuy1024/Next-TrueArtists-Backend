class ConventionSearch < BaseSearch
  private def search_class
    Convention
  end

  def filter
    search_results = if options[:near] && location
                       search_class.search(query,
                                           page: options[:page] || 1,
                                           per_page: options[:per_page] || PER_PAGE,
                                           boost_by_distance: {
                                             location: {
                                               origin: location
                                             }
                                           },
                                           where: {
                                             location: {
                                               near: location,
                                               within: options[:within]
                                             }
                                           }.merge(filter_constraints))
                     else
                       search_class.search(query,
                                           page: options[:page] || 1,
                                           per_page: options[:per_page] || PER_PAGE,
                                           where: filter_constraints)
                     end

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      conventions: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                     serializer: ConventionSerializer),
      meta: meta
    }
  end

  def filter_constraints
    return {} if options[:user_role] == 'admin'

    {
      verified: true,
      start_date: Date.tomorrow..
    }.delete_if { |_k, v| v.nil? }
  end
end
