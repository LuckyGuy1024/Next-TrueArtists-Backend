class LocationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :country,
             :state,
             :city,
             :lat,
             :lon,
             :avatar,
             :hero_banner

  def avatar
    if object.avatar.attached?
      {
        id: object.avatar.id,
        image_url: asset_blob_url(object.avatar),
        status: object.avatar.status
      }
    end
  end

  def hero_banner
    if object.hero_banner.attached?
      {
        id: object.hero_banner.id,
        image_url: asset_blob_url(object.hero_banner)
      }
    end
  end
end
