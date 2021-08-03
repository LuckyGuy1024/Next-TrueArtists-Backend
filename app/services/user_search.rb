class UserSearch < BaseSearch
  private def search_class
    User
  end

  def filter
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      users: results,
      meta: meta
    }
  end
end
