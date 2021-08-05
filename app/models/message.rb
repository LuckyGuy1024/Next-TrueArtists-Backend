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

  has_many :message_mails
  has_one :booking, required: false

  has_many_attached :attachments

  scope :threads, -> { pluck(:thread_id).uniq }

  before_validation :assign_thread_id, on: :create
  after_commit :send_user_notification, on: :create

  def self.build_message(sender, message)
    Message.new({
      content: message[:content],
      sender_id: sender.id,
      receiver_id: message[:receiver_id],
      message_type: message[:message_type],
      thread_id: message[:thread_id]
    }.delete_if { |_thread_id, v| v.nil? })
  end

  private

  def send_user_notification
    return if message_type == self.class.message_types[:appointment].downcase
    MessageMailingService.new(self).send
    # MessageSmsService.new(self, @@result[:phone]).send unless @@result[:phone].nil?
  end

  def assign_thread_id
    self.thread_id = SecureRandom.uuid unless thread_id
  end
end
