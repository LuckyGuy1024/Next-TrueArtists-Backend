# frozen_string_literal: true

class Booking < ApplicationRecord
  PLACEMENTS = ['Head', 'Neck', 'Shoulder', 'Chest', 'Back',
                'Arm', 'Forearm', 'Ribs', 'Hip', 'Thigh',
                'Lower Leg', 'Foot'].freeze

  enum size_units: {
    cm: 'Centimeters',
    in: 'Inches'
  }

  searchkick locations: [:location],
             searchable: %i[status tattoo_placement description receiver_id sender_id],
             filterable: %i[first_tattoo size_units consult_artist tattoo_placement colored_tattoo status]

  validates :tattoo_placement, :description, presence: true
  # validates_presence_of :custom_size, :size_units,
  #                       message: 'Can\'t be blank if consult_artist=false',
  #                       unless: lambda { :consult_artist == true }
  belongs_to :message
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id', validate: true
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', validate: true

  has_many_attached :images

  after_commit :booking_notification

  scope :sender_bookings, ->(user_id) { where(sender_id: user_id) }
  scope :receiver_bookings, ->(user_id) { where(receiver_id: user_id) }
  scope :user_bookings, ->(user_id) { sender_bookings(user_id).or(receiver_bookings(user_id)) }

  private

  def booking_notification
    BookingMailer.new_booking_notification(self).deliver_now
  end
end
