class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id,
             :email,
             :full_name,
             :role,
             :status,
             :slug,
             :formatted_address,
             :unread_inbox_count,
             :studio,
             :artist,
             :avatar

  def artist
    return nil unless object.artist

    {
      id: object.artist.id,
      name: object.artist.name
    }
  end

  def studio
    return nil unless object.studio

    {
      id: object.studio.id,
      name: object.studio.name
    }
  end

  def avatar
    if object.avatar.attached?
      {
        id: object.avatar.id,
        image_url: asset_blob_url(object.avatar)
      }
    end
  end
end
