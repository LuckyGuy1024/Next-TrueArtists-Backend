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
      name: object.sender.full_name
    }
  end

  def receiver
    {
      id: object.receiver.id,
      name: object.receiver.full_name
    }
  end
end
