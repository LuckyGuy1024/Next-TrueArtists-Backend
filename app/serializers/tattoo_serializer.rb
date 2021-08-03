class TattooSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :artist
  belongs_to :studio

  attributes :id,
             :style,
             :categories,
             :placement,
             :description,
             :color,
             :size,
             :tags,
             :caption,
             :featured,
             :status,
             :image,
             :created_at

  def image
    if object.image.attached?
      {
        id: object.image.id,
        name: object.image.filename,
        image_url: asset_blob_url(object.image),
      }
    end
  end

  def tags
    return [] if object.tag_list.nil?

    object.tag_list.split(',')
  end

  def style
    return {} unless object.style
    {
      id: object.style.id,
      name: object.style.name
    }
  end
end
