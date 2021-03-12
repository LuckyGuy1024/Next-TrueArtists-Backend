class TattooSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :artist
  belongs_to :studio
  attributes :id,
             :styles,
             :categories,
             :placement,
             :description,
             :color,
             :size,
             :tags,
             :status,
             :image

  def image
    if object.image.attached?
      {
        id: object.image.id,
        image_url: ENV['HOST'] + rails_blob_path(object.image, only_path: true),
        name: object.image.filename
      }
    end
  end

  def tags
    return [] if object.tag_list.nil?

    object.tag_list.split(',')
  end
end
