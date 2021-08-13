class ArtistSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  has_many :tattoos
  has_many :styles

  attributes :id,
             :user_id,
             :name,
             :bio,
             :slug,
             :licensed,
             :status,
             :years_of_experience,
             :cpr_certified,
             :specialty,
             :styles,
             :website,
             :facebook_url,
             :twitter_url,
             :instagram_url,
             :phone_number,
             :minimum_spend,
             :price_per_hour,
             :currency_code,
             :street_address,
             :street_address_2,
             :zip_code,
             :city,
             :state,
             :country,
             :seeking_guest_spot,
             :guest_artist,
             :avatar,
             :hero_banner,
             :has_styles,
             :has_social_profiles,
             :has_tattoo_gallery,
             :has_avatar

  def avatar
    if object.avatar.attached?
      {
        id: object.avatar.id,
        image_url: asset_blob_url(object.avatar)
      }
    end
  end

  def hero_banner
    if object.hero_banner.attached?
      {
        id: object.hero_banner.id,
        image_url: asset_blob_url(object.hero_banner),
      }
    end
  end
end
