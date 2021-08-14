# frozen_string_literal: true

class Booking < ApplicationRecord
  include AASM

  TATTOO_COLORS = [
    'Colored',
    'Black & White',
    'Mixed',
    'Consult with artist'
  ]

  TATTOO_SIZES = {
    centimeters: [
      '1-5 cm',
      '5-10 cm',
      '10-20 cm',
      '20-30 cm',
      '+ 30 cm',
      'Consult with artist'
    ],
    inches: [
      '1-5 inch',
      '5-10 inch',
      '10-20 inch',
      '20-30 inch',
      '+ 20 inch',
      'Consult with artist'
    ]
  }

  enum size_units: {
    cm: 'Centimeters',
    in: 'Inches'
  }

  searchkick locations: [:location],
             searchable: %i[status tattoo_placement description receiver_id sender_id],
             filterable: %i[first_tattoo tattoo_placement tatoo_color status]

  belongs_to :conversation
  belongs_to :bookable, polymorphic: true
  belongs_to :user, validate: true

  has_many_attached :images

  validates :tattoo_placement, :description, :conversation_id, presence: true

  aasm column: 'status' do
    state :pending_review, initial: true
    state :accepted
    state :rejected
    state :canceled

    event :accept do
      transitions from: %i[pending_review canceled rejected], to: :accepted
    end

    event :reject do
      transitions from: %i[pending_review canceled], to: :rejected
    end

    event :cancel do
      transitions from: %i[pending_review accepted], to: :canceled
    end
  end

  after_commit :booking_notification

  scope :sender_bookings, ->(user_id) { where(sender_id: user_id) }
  scope :receiver_bookings, ->(user_id) { where(receiver_id: user_id) }
  scope :user_bookings, ->(user_id) { sender_bookings(user_id).or(receiver_bookings(user_id)) }

  private

  def booking_notification
    BookingMailer.new_booking_notification(self).deliver_now
  end
end
