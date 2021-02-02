class StudioSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  has_many :artists


  attributes :id,
             :user_id,
             :name,
             :bio,
             :city,
             :state,
             :street_address,
             :zip_code,
             :country,
             :phone_number,
             :specialty,
             :accepted_payment_methods,
             :appointment_only,
             :languages,
             :services,
             :email,
             :facebook_url,
             :twitter_url,
             :instagram_url,
             :website_url,
             :lat,
             :lon,
             :status,
             :slug,
             :accepting_guest_artist,
             :piercings,
             :cosmetic_tattoos,
             :vegan_ink,
             :wifi,
             :privacy_dividers,
             :wheelchair_access,
             :parking,
             :lgbt_friendly,
             :price_per_hour,
             :studio_images

  def studio_images
    object.studio_images.map do |image|
      {
        id: image.id,
        name: image.filename,
        image_url: rails_blob_path(image, only_path: true)
      }
    end
  end
end
