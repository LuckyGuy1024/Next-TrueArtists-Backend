class MessageSerializer < ActiveModel::Serializer
  has_one :booking
  belongs_to :sender
  belongs_to :receiver

  attributes :id,
             :subject,
             :content,
             :message_type,
             :sender_deleted,
             :receiver_deleted,
             :thread_id

end
