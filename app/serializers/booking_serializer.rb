class BookingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :bookable

  attributes :id,
             :bookable_id,
             :bookable_type,
             :description,
             :tattoo_placement,
             :consult_artist,
             :custom_size,
             :status,
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
