class BookingMailer < ApplicationMailer
  layout 'perfect_mailer'

  def new_booking_notification(booking)
    @booking = booking
    @bookable = booking.bookable
    @user = booking.user
    mail(to: @bookable.email,
         personalizations: [{ to: [{ email: @bookable.email }] }],
         subject: "You have a new booking request from #{@user.full_name}")
  end

  def accepted_booking_notification(booking)
    @booking = booking
    @bookable = booking.bookable
    @user = booking.user
    mail(to: @bookable.email,
         personalizations: [{ to: [{ email: @bookable.email }] }],
         subject: 'Congratulations! Your booking request has been accepted!')
  end

  def rejected_booking_notification(booking)
    @booking = booking
    @bookable = booking.bookable
    @user = booking.user
    mail(to: @bookable.email,
         personalizations: [{ to: [{ email: @bookable.email }] }],
         subject: 'Sorry, Your booking request has been rejected')
  end

  def canceled_booking_notification(booking)
    @booking = booking
    @bookable = booking.bookable
    @user = booking.user
    mail(to: @bookable.email,
         personalizations: [{ to: [{ email: @bookable.email }] }],
         subject: 'Sorry, one of your customers has canceled their booking request.')
  end

  def reminder(booking, subject)
    @booking = booking
    @bookable = booking.bookable
    @user = booking.user
    mail(to: @bookable.email,
         personalizations: [{ to: [{ email: @bookable.email }] }],
         subject: subject)
  end
end
