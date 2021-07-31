# frozen_string_literal: true

class Booking < ApplicationRecord

  PLACEMENTS = ['Head', 'Neck', 'Shoulder', 'Chest', 'Back',
                'Arm', 'Forearm', 'Ribs', 'Hip', 'Thigh',
                'Lower Leg', 'Foot'].freeze

  enum size_units: {
    cm: 'Centimeters',
    in: 'Inches'
  }

  validates :first_tattoo, :colored, presence: true
  validates_presence_of :custom_size, :size_units, message: 'Can\'t be blank if consult_artist=false', unless: lambda {
    :consult_artist == true
                                                                                                               }

  belongs_to :message
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id', validate: true
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', validate: true

  has_many_attached :images

  def self.build_booking(sender, booking)
    # create message
    message_params = {
      content: booking[:description],
      message_type: 'Book Appointment',
      recipient_type: booking[:recipient_type],
      recipient_id: booking[:recipient_id],
      thread_id: thread_id(sender.id, booking)
    }.delete_if { |_thread_id, v| v.nil? }

    message = Message.build_message(sender, message_params)

    return unless message.save

    message.build_booking({
                            description: booking[:description],
                            sender_id: sender.id,
                            receiver_id: message.receiver_id,
                            placement: booking[:placement],
                            consult_artist: booking[:consult_artist],
                            custom_size: booking[:custom_size],
                            urgency: booking[:urgency],
                            first_tattoo: booking[:first_tattoo],
                            colored: booking[:colored],
                            size_units: booking[:size_units]
                          })
  end

  private

  def self.thread_id(sender, booking)
    recipient = booking[:recipient_type].constantize.find(booking[:recipient_id])

    id = if recipient.instance_of?(Studio) || recipient.instance_of?(Artist)
           recipient.user_id
         else
           recipient.id
         end

    message = Message.find_by(sender_id: sender, receiver_id: id)

    return if message.nil?

    message.thread_id
  end

  def send_user_notification
    BookingMailingService.new(self).send
    BookingSmsService.new(self, @@result[:phone]).send unless @@result[:phone].nil?
  end
end
