module Legacy
  class ArtistLanguage < Base
    self.abstract_class = true
    self.table_name = "artist_languages"
    belongs_to :artist, class_name: 'Legacy::Artist'
    belongs_to :studio, class_name: 'Legacy::Studio'
  end
end
