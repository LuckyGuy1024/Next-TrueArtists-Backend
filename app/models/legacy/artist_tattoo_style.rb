module Legacy
  class ArtistTattooStyle < Base
    self.abstract_class = true
    self.table_name = "artists_tattoo_styles"
    connects_to database: { reading: :legacy, writing: :primary }

    belongs_to :artist, class_name: 'Legacy::Artist'
    belongs_to :tattoo_style, class_name: 'Legacy::TattooStyle'
  end
end
