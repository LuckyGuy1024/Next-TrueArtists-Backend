class Message < ApplicationRecord
  include AssetExtension
  DEFAULT_BOOKING_MESSAGE = 'You have a new booking inquiry from TrueArtists'

  enum message_type: {
    appointment: 'Appointment',
    advice: 'Advice',
    consultation: 'Consultation',
    pricing_questions: 'Pricing Questions',
    other: 'Other'
  }

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id', validate: true
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', validate: true

  belongs_to :conversation
  has_many :message_mails
  has_many_attached :attachments

  scope :threads, -> { pluck(:thread_id).uniq }

  validates :content, :conversation_id, presence: true
  before_validation :assign_thread_id, on: :create
  after_commit :send_user_notification, on: :create

  private

  def send_user_notification
    return if email_client_reply
    return if message_type == self.class.message_types[:appointment].downcase

    MessageMailingService.new(self).send
    # MessageSmsService.new(self, @@result[:phone]).send unless @@result[:phone].nil?
  end

  def assign_thread_id
    self.thread_id = SecureRandom.uuid unless thread_id
  end
end
