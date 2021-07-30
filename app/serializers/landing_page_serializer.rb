class LandingPageSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id,
             :page_key,
             :page_title,
             :meta_description,
             :title,
             :content,
             :moved_to,
             :status,
             :avatar,
             :last_updated_by

  def last_updated_by
    object.user.full_name
  end

  def avatar
    if object.avatar.attached?
      {
        id: object.avatar.id,
        image_url: asset_blob_url(object.avatar),
      }
    end
  end
end
