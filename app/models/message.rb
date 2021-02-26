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
end
