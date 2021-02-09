class TattooSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :artist
  belongs_to :studio
  attributes :id,
             :styles,
             :categories,
             :placement,
             :color,
             :size,
             :image

  def image
    if object.image.attached?
      {
        id: object.image.id,
        image_url: rails_blob_path(object.image, only_path: true),
        name: object.image.filename
      }
    end
  end
end
