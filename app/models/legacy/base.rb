module Legacy
  class Base < ActiveRecord::Base
    self.abstract_class = true
    connects_to database: { reading: :legacy, writing: :primary }
  end
end
