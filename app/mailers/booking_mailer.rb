class BookingMailer < ApplicationMailer
  def new_booking_notification(booking)
    @booking = booking
    @receiver = booking.receiver
    @sender = booking.sender
    mail(to: @receiver.email, subject: 'You have a new booking')
  end
end
