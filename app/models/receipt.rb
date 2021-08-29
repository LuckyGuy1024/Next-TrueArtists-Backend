class Receipt < ApplicationRecord
  searchkick #searchable: %i[content read archived receiver_id receiver_type mailbox_type deleted]

  belongs_to :message
  belongs_to :receiver, polymorphic: :true, required: false
  validates_presence_of :receiver

  scope :outbox, -> { where(mailbox_type: 'sentbox') }
  scope :inbox, -> { where(mailbox_type: 'inbox') }
  scope :archived, -> { where(archived: true) }
  scope :not_archived, -> { where(archived: false) }
  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }

  scope :for_receiver, lambda { |receiver|
    where(receiver_id: receiver.id, receiver_type: receiver.class.base_class.to_s)
  }

  def conversation
    message.conversation
  end

  def search_data
    {
      content: message.content
    }
  end
end
