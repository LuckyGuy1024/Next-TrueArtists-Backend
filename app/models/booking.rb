# frozen_string_literal: true

class Booking < ApplicationRecord
  include AASM

  MAX_REMINDER_AMOUNT = 2.freeze
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

  searchkick searchable: %i[status email user_id bookable_type bookable_id phone_number full_name]

  belongs_to :conversation
  belongs_to :style
  belongs_to :bookable, polymorphic: true
  belongs_to :user, validate: true

  has_many_attached :images, dependent: :destroy

  validates :tattoo_placement, :description, :conversation_id, presence: true

  aasm column: 'status' do
    state :pending_review, initial: true
    state :accepted
    state :rejected
    state :canceled
    state :archived

    event :accept do
      transitions from: %i[pending_review canceled rejected], to: :accepted
    end

    event :reject do
      transitions from: %i[pending_review canceled], to: :rejected
    end

    event :cancel do
      transitions from: %i[pending_review accepted], to: :canceled
    end

    event :archive do
      transitions from: %i[pending_review accepted], to: :archived
    end
  end

  after_commit :booking_notification, on: :create

  scope :sender_bookings, ->(user_id) { where(sender_id: user_id) }
  scope :receiver_bookings, ->(user_id) { where(receiver_id: user_id) }
  scope :user_bookings, ->(user_id) { sender_bookings(user_id).or(receiver_bookings(user_id)) }
  scope :requires_archiving, -> { pending_review.where("reminder_count >= ? AND created_at < ?", MAX_REMINDER_AMOUNT, 5.days.ago) }
  scope :requires_reminder, -> { pending_review.where("reminder_count < ? AND created_at < ?", MAX_REMINDER_AMOUNT, 24.hours.ago) }

  def search_data
    attributes.merge(
      full_name: user.full_name,
      email: user.email)
  end

  private

  def booking_notification
    BookingMailer.new_booking_notification(self).deliver_now
  end
end
