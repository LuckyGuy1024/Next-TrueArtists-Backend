class BookingsArchivingJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # TO-DO: Find a better way to handle errors
    Rails.logger.error exception
  end

  def perform
    Booking.requires_archiving.find_each do |booking|
      booking.archive!
    end
  end
end
