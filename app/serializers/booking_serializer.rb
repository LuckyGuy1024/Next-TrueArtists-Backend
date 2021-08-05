class BookingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  belongs_to :sender
  belongs_to :receiver

  attributes :id,
             :description,
             :tattoo_placement,
             :consult_artist,
             :custom_size,
             :city,
             :height,
             :width,
             :urgency,
             :size_units,
             :first_tattoo,
             :colored_tattoo,
             :images

  def urgency
    object.urgency.strftime("%d-%m-%Y") if object.urgency
  end

  def images
    return unless object.images.attached?

    object.images.each do |image|
      {
        id: image.id,
        image_url: asset_blob_url(image),
        name: image.filename
      }
    end
  end
end
