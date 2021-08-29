class Conversation < ApplicationRecord
  has_one :booking, required: false
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  has_many :messages, dependent: :destroy
  has_many :receipts, through: :messages, class_name: 'Receipt'

  validates_uniqueness_of :sender_id, scope: :receiver_id

  scope :between, lambda { |sender_id, receiver_id|
                    where('(conversations.sender_id = ? AND conversations.receiver_id = ?) OR (conversations.receiver_id = ? AND conversations.sender_id = ?)', sender_id, receiver_id, sender_id, receiver_id)
                  }
  def archive!
    self.archive = true
    save
  end

  def mark_as_read(receiver)
    return unless receiver
    unread_receipts_for(receiver).update_all(read: true)
  end

  def mark_as_unread(receiver)
    return unless receiver
    read_receipts_for(receiver).update_all(read: true)
  end

  def receipts_for(receiver)
    return [] unless receiver
    receipts.inbox.for_recipient(receiver)
  end

  def unread_receipts_for(receiver)
    return [] unless receiver
    receipts_for(receiver).is_unread
  end

  def read_receipts_for(receiver)
    receipts_for(receiver).is_read
  end

  def read_all?(receiver)
    unread_receipts_for(receiver).none?
  end
end
