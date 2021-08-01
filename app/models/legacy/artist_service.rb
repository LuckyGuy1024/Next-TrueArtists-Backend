module Legacy
  class ArtistService< Base
    self.abstract_class = true
    self.table_name = "artist_services"
    belongs_to :artist, class_name: 'Legacy::Artist'
    belongs_to :service, class_name: 'Legacy::Service'
  end
end
