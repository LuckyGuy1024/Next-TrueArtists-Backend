class BookingMailer < ApplicationMailer
  def booking_notification(booking)
    receiver_email = booking.receiver.email
    @sender_email = booking.sender.email

    mail(to: receiver_email, subject: 'New Booking Alert')
  end
end
