class Message < ApplicationRecord
  include AssetExtension

  enum message_type: {
    consultation: 'Consultation',
    advice: 'Advice',
    pricing_questions: 'Pricing Questions',
    book_appointment: 'Book Appointment',
    other: 'Other'
  }

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id', validate: true
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', validate: true

  has_many :message_mails

  has_many_attached :attachments

  scope :threads, -> { pluck(:thread_id).uniq }

  before_save :assign_thread_id
  after_create :send_user_notification

  def self.build_message(sender, message)
    Message.new({
      content: message[:content],
      sender_id: sender.id,
      receiver_id: receiver_id(message)[:id],
      message_type: message[:message_type],
      thread_id: message[:thread_id]
    }.delete_if { |_thread_id, v| v.nil? })
  end

  private

  def send_user_notification
    MessageMailingService.new(self).send
    MessageSmsService.new(self, @@result[:phone]).send unless @@result[:phone].nil?
  end

  def self.receiver_id(message)
    recipient = message[:recipient_type].constantize.find(message[:recipient_id])

    @@result = if recipient.instance_of?(Studio) || recipient.instance_of?(Artist)
                 { id: recipient.user_id, phone: recipient.phone_number }
               else
                 { id: recipient.id, phone: nil }
               end
  end

  def assign_thread_id
    self.thread_id = random_thread_id unless thread_id
  end

  def random_thread_id
    rand(100**10).to_s.center(10, rand(10).to_s)
  end
end
