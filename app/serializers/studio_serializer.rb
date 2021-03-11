class StudioSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  has_many :artists
  has_many :tattoos

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
             :avatar,
             :hero_banner

  def avatar
    if object.avatar.attached?
      {
        id: object.avatar.id,
        image_url: ENV['HOST'] + rails_blob_path(object.avatar, only_path: true),
        name: object.avatar.filename
      }
    end
  end

  def hero_banner
    if object.hero_banner.attached?
      {
        id: object.hero_banner.id,
        image_url: ENV['HOST'] + rails_blob_path(object.hero_banner, only_path: true),
        name: object.hero_banner.filename
      }
    end
  end
end
