class AnnouncementSearch < BaseSearch
  private def search_class
    Announcement
  end

  def filter
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      announcements: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                  serializer: AnnouncementSerializer),
      meta: meta
    }
  end

  def adminFilter
    search_results = base_filter

    self.results = search_results.results
    self.meta = pagination_info(search_results)

    {
      announcements: ActiveModel::Serializer::CollectionSerializer.new(results,
                                                                  serializer: AdminAnnouncementSerializer),
      meta: meta
    }
  end
end
