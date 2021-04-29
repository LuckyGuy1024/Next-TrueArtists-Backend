# frozen_string_literal: true

module Legacy
  class Photo < Base
    def self.migrate
      connected_to(role: :reading) do
        find_each do |tattoo|
          connected_to(role: :writing) do
            new_tattoo = ::Tattoo.find_or_initialize_by(artist_id: tattoo.photoable_id, description: tattoo.description)

            new_tattoo.styles = tattoo.tattoo_styles
            new_tattoo.categories = tattoo.tattoo_categories
            new_tattoo.placement = tattoo.tattoo_placements
            new_tattoo.color = tattoo.tattoo_colors
            new_tattoo.size = tattoo.tattoo_sizes
            new_tattoo.tag_list = tattoo.tags

            new_tattoo.save

            if new_tattoo.save && tattoo.attachment_file_name
              image = tattoo.attachment_file_name
              ext = File.extname(image)
              image_original = CGI.unescape(image.gsub(ext, "_original#{ext}"))

              attachment_url = "https://s3.amazonaws.com/trueartists_production/attachments/#{tattoo.id}/original/#{image_original}"
              new_tattoo.image.attach(io: open(attachment_url),
                                      filename: tattoo.attachment_file_name,
                                      content_type: tattoo.attachment_content_type)
            end
          end
        end
      end
    end
  end
end
