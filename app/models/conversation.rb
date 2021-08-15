class Conversation < ApplicationRecord
  has_one :booking, required: false
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, scope: :receiver_id

  scope :between, lambda { |sender_id, receiver_id|
                    where('(conversations.sender_id = ? AND conversations.receiver_id = ?) OR (conversations.receiver_id = ? AND conversations.sender_id = ?)', sender_id, receiver_id, sender_id, receiver_id)
                  }
  def archive!
    self.archive = true
    save
  end

  def read!
    self.read = true
    save
  end

  def unread!
    self.read = false
    save
  end
end
