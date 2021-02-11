class ArtistSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  has_many :tattoos

  attributes :id,
             :user_id,
             :name,
             :slug,
             :licensed,
             :years_of_experience,
             :styles,
             :website,
             :facebook_url,
             :twitter_url,
             :instagram_url,
             :phone_number,
             :minimum_spend,
             :price_per_hour,
             :currency_code,
             :city,
             :zip_code,
             :country,
             :seeking_guest_spot,
             :guest_artist,
             :avatar,
             :hero_banner

  def name
    object.user.full_name
  end

  def avatar
    if object.avatar.attached?
      {
        id: object.avatar.id,
        image_url: rails_blob_path(object.avatar, only_path: true),
        name: object.avatar.filename
      }
    end
  end

  def hero_banner
    if object.hero_banner.attached?
      {
        id: object.hero_banner.id,
        image_url: rails_blob_path(object.hero_banner, only_path: true),
        name: object.hero_banner.filename
      }
    end
  end
end
