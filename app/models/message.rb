class Message < ApplicationRecord
  include AssetExtension
  DEFAULT_BOOKING_MESSAGE = 'You have a new booking inquiry from TrueArtists'

  enum message_type: {
    booking: 'Booking',
    consultation: 'Consultation',
    pricing_questions: 'Pricing',
    other: 'Other'
  }, _prefix: true

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id', validate: true
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', validate: true

  has_one :booking
  belongs_to :conversation
  has_many :message_mails, dependent: :destroy
  has_many :receipts, dependent: :destroy
  has_many_attached :attachments, dependent: :destroy

  scope :threads, -> { pluck(:thread_id).uniq }

  validates :content, :conversation_id, presence: true
  before_validation :assign_thread_id, on: :create
  after_commit :deliver, on: :create

  private

  def deliver
    # Receiver receipt
    receipts.build(receiver: receiver, mailbox_type: 'inbox', read: false)

    # Sender receipt
    receipts.build(receiver: sender, mailbox_type: 'outbox', read: true)

    save if valid?

    return if email_client_reply
    return if message_type_booking?
    return unless conversation.booking.blank?

    MessageMailingService.new(self).send
    # MessageSmsService.new(self, @@result[:phone]).send unless @@result[:phone].nil?
  end

  def assign_thread_id
    self.thread_id = SecureRandom.uuid unless thread_id
  end
end
