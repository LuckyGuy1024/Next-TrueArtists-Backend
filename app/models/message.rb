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

  def self.build_message(sender, message, recipient)
    binding.pry
    Message.new({
      content: "description: #{message[:description]},
                placement: #{message[:placement]},
                size: #{message[:size]},
                urgency: #{message[:urgency]},
                is this your first tattoo: #{message[:first_time]}",
      sender_id: sender.id,
      receiver_id: recipient,
      message_type: message[:message_type],
      thread_id: message[:thread_id]
    }.delete_if { |_thread_id, v| v.nil? })
  end
end
