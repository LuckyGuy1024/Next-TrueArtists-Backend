module Legacy
  class ArtistSpeciality < ActiveRecord::Base
    self.abstract_class = true
    self.table_name = "artist_specialities"
    connects_to database: { reading: :legacy, writing: :primary }
    belongs_to :artist, class_name: 'Legacy::Artist'
    belongs_to :speciality, class_name: 'Legacy::Speciality'
  end
end
