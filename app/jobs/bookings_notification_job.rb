class BookingsNotificationJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # TO-DO: Find a better way to handle errors
    Rails.logger.error exception
  end

  def perform
    Booking.where(status: 'pending_review').where("reminder_count < ?", Booking::MAX_REMINDER_AMOUNT).pluck(:id).each do |booking_id|
      BookingNotificationJob.perform_later(booking_id)
    end
  end
end
