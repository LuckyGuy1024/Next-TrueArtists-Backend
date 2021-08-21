class ConversationSerializer < ActiveModel::Serializer
  has_one :booking
  has_many :messages

  attributes :id,
             :sender,
             :receiver,
             :read,
             :archive,
             :updated_at,
             :created_at

  def sender
    {
      id: object.sender.id,
      name: display_name(object.sender)
    }
  end

  def receiver
    {
      id: object.receiver.id,
      name: display_name(object.receiver)
    }
  end

  def display_name(object)
    return object.artist.name if object.role_is?('artist')
    return object.studio.name if object.role_is?('studio_manager')

    object.full_name
  end
end
