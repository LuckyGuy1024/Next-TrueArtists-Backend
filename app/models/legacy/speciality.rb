module Legacy
  class Speciality < Base
    self.abstract_class = true
    self.table_name = "specialities"
    connects_to database: { reading: :legacy, writing: :primary }
  end
end
