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
