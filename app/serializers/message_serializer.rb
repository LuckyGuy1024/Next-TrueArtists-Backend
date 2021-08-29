class MessageSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  has_one :booking

  attributes :id,
             :subject,
             :content,
             :sender,
             :receiver,
             :message_type,
             :sender_deleted,
             :receiver_deleted,
             :thread_id,
             :is_read,
             :created_at

  def sender
    {
      id: object.sender.id,
      name: display_name(object.sender)
    }.merge(avatar(object.sender))
  end

  def receiver
    {
      id: object.receiver.id,
      name: display_name(object.receiver)
    }.merge(avatar(object.receiver))
  end

  def avatar(object)
    if object.artist && object.artist.avatar.attached?
      return { avatar_url: asset_blob_url(object.artist.avatar) }
    end
    if object.studio && object.studio.avatar.attached?
      return { avatar_url: asset_blob_url(object.studio.avatar) }
    end
    return { avatar_url: asset_blob_url(object.avatar) } if object.avatar.attached?

    { avatar_url: nil }
  end

  def display_name(object)
    return object.artist.name if object.role_is?('artist')
    return object.studio.name if object.role_is?('studio_manager')

    object.full_name
  end
end
