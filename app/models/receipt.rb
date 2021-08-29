class Receipt < ApplicationRecord
  belongs_to :message
  belongs_to :receiver, polymorphic: :true, required: false
  validates_presence_of :receiver

  scope :outbox, -> { where(mailbox_type: 'sentbox') }
  scope :inbox, -> { where(mailbox_type: 'inbox') }
  scope :is_read, -> { where(read: true) }
  scope :is_unread, -> { where(read: false) }

  scope :for_recipient, lambda { |recipient|
    where(receiver_id: recipient.id, receiver_type: recipient.class.base_class.to_s)
  }
end
