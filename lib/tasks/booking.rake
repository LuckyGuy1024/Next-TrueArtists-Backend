# frozen_string_literal: true

namespace :booking do
  task reminders: :environment do
    puts 'Starting Booking Reminders'
    BookingsNotificationJob.perform_now
    puts 'Finishing Booking Reminders'
  end

  task archiving: :environment do
    puts 'Starting Booking Archiving'
    BookingsArchivingJob.perform_now
    puts 'Finishing Booking Archiving'
  end
end
