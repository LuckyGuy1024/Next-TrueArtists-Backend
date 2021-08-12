class MessageMail < ApplicationRecord
  belongs_to :message
  belongs_to :user

  validates :thread_id, :message_id, :user_id, presence: true
end
