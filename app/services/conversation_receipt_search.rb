class ConversationReceiptSearch < BaseSearch
  private def search_class
    Receipt
  end

  def filter
    search_results = base_filter
    self.results = search_results.map { |receipt| receipt.conversation }.uniq
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
      read: options[:read],
      deleted: options[:deleted],
      archived: options[:archived],
      receiver_id: options[:receiver_id]
    }.delete_if { |_k, v| v.nil? }

    search_class.search(query, **constraints)
  end
end
