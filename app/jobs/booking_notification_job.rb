class BookingNotificationJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # TO-DO: Find a better way to handle errors
    Rails.logger.error exception
  end

  def perform(booking_id)
    subject = {
      0 => 'Reminder: You have a pending bookings request',
      1 => 'Final Reminder: You have a pending bookings request',
    }

    booking = Booking.find(booking_id)

    return if booking.reminder_count > Booking::MAX_REMINDER_AMOUNT

    case booking.status
    when 'pending_review '
      ArtistMailer.complete_profile_reminder(artist, subject[booking.reminder_count]).deliver_now
    else
      return
    end

    # update reminder count
    booking.update(reminder_count: booking.reminder_count + 1)
  end
end
