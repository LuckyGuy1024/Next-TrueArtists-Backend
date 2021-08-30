class BookingNotificationJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # TO-DO: Find a better way to handle errors
    Rails.logger.error exception
  end

  def perform(booking_id)
    booking = Booking.find(booking_id)

    subject = {
      0 => "Reminder: You have a pending booking request from #{booking.user&.full_name}",
      1 => "Final Reminder: Respond to #{booking.user&.full_name}'s booking request",
    }

    return if booking.reminder_count > Booking::MAX_REMINDER_COUNT

    case booking.status
    when 'pending_review'
      BookingMailer.reminder(booking, subject[booking.reminder_count]).deliver_now
    else
      return
    end

    # update reminder count
    booking.update(reminder_count: booking.reminder_count + 1)
  end
end
