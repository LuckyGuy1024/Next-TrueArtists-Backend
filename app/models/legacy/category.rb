# frozen_string_literal: true

module Legacy
  class Category < Base
    self.abstract_class = true
    self.table_name = "categories"
    connects_to database: { reading: :legacy, writing: :primary }

    def self.migrate
      ActiveRecord::Base.connected_to(role: :reading) do
        find_each do |category|
          ActiveRecord::Base.connected_to(role: :writing) do
            new_category = ::Category.find_or_initialize_by(name: category.name)
            new_category.save(validate: false)
          end
        end
      end
    end
  end
end
