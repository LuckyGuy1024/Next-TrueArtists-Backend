# frozen_string_literal: true

module Legacy
  class TattooStyle < Base
    self.abstract_class = true
    self.table_name = "tattoo_styles"
    connects_to database: { reading: :legacy, writing: :primary }

    has_many :artist_tattoo_styles

    # connects_to database: { reading: :legacy, writing: :primary }

    def self.migrate
      ActiveRecord::Base.connected_to(role: :reading) do
        find_each do |style|
          ActiveRecord::Base.connected_to(role: :writing) do
            new_style = ::Style.find_or_initialize_by(id: style.id, name: style.name)
            new_style.save
          end
        end
      end
    end
  end
end
