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

  scope :for_receiver, lambda { |receiver|
                         order(updated_at: :desc)
                           .joins(:receipts).merge(Receipt.for_receiver(receiver).not_archived).distinct
                       }
  scope :unread, lambda { |receiver|
    joins(:receipts).merge(Receipt.for_receiver(receiver).not_archived.unread).distinct
  }

  scope :archived, lambda { |receiver|
                     order(updated_at: :desc)
                       .joins(:receipts).merge(Receipt.for_receiver(receiver).archived).distinct
                   }

  def mark_as_archived(receiver)
    receipts_for(receiver).not_archived.update_all(archived: true)
    self.archived = true
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

    receipts.inbox.for_receiver(receiver)
  end

  def unread_receipts_for(receiver)
    return [] unless receiver

    receipts_for(receiver).unread
  end

  def read_receipts_for(receiver)
    receipts_for(receiver).read
  end

  def read_all?(receiver)
    unread_receipts_for(receiver).none?
  end
end
