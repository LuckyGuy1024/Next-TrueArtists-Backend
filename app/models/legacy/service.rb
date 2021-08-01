module Legacy
  class Service < Base
    self.abstract_class = true
    self.table_name = "services"
  end
end
