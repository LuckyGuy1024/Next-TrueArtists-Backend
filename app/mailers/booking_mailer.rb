class BookingMailer < ApplicationMailer
  def new_booking_notification(booking)
    @booking = booking
    @bookable = booking.bookable
    @user = booking.user
    mail(to: @bookable.email, subject: 'You have a new booking')
  end
end
