class BookingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :description,
             :tattoo_placement,
             :tattoo_color,
             :tattoo_size,
             :budget,
             :style,
             :phone_number,
             :availability,
             :formatted_address,
             :first_tattoo,
             :status,
             :created_at,
             :images,
             :user,
             :bookable

  def user
    {
      id: object.user_id,
      name: object.user.full_name,
      email: object.user.email
    }
  end

  def bookable
    {
      id: object.bookable_id,
      name: object.bookable.name,
      bookable_type: object.bookable_type
    }
  end

  def created_at
    object.created_at.strftime('%d-%m-%Y')
  end

  def style
    object.style.name if object.style
  end

  def images
    return unless object.images.attached?

    object.images.each_with_object([]) do |image, array|
      array << {
        id: image.id,
        image_url: asset_blob_url(image),
        name: image.filename
      }
    end
  end
end
