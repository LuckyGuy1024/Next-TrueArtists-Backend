module Legacy
  class TattooCategory < Base
    self.abstract_class = true
    self.table_name = "tattoo_categories"
    belongs_to :category, class_name: 'Legacy::Category'
    belongs_to :artist, class_name: 'Legacy::Artist'
  end
end
