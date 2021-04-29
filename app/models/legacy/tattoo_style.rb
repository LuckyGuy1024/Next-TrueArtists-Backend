# frozen_string_literal: true

module Legacy
  class TattooStyle < Base
    def self.migrate
      connected_to(role: :reading) do
        find_each do |style|
          connected_to(role: :writing) do
            new_style = Style.find_or_initialize_by(name: style.name)
          end
        end
      end
    end
  end
end
