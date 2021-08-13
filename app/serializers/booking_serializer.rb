class BookingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :bookable

  attributes :id,
             :description,
             :tattoo_placement,
             :tattoo_color,
             :tattoo_size,
             :budget,
             :style_id,
             :phone_number,
             :availability,
             :city,
             :urgency,
             :bookable_type,
             :bookable_id,
             :first_tattoo,
             :status,
             :images

  def urgency
    object.urgency.strftime('%d-%m-%Y') if object.urgency
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
