# frozen_string_literal: true

namespace :complete_profile_schedule do
  task reminder: :environment do
    puts 'Starting scheduling studio complete profile reminders'
    Studio.where(status: 'pending').find_each do |studio|
      # time in hours from when created to now
      time_diff = ((Time.now - studio.created_at) / 1.hour).round

      case time_diff
      when 8..24
        ArtistNotificationJob.set(wait_until: (studio.created_at + 1.day)).perform_later(studio.id)
      when 25..168
        ArtistNotificationJob.set(wait_until: (studio.created_at + 7.days)).perform_later(studio.id)
      when 169..336
        ArtistNotificationJob.set(wait_until: (studio.created_at + 14.days)).perform_later(studio.id)
      end
    end
    puts 'Finishing scheduling artist complete profile reminders'

    puts 'Starting scheduling artist complete profile reminders'
    Artist.where(status: 'pending').find_each do |artist|
      # time in hours from when created to now
      time_diff = ((Time.now - artist.created_at) / 1.hour).round

      case time_diff
      when 8..24
        StudioNotificationJob.set(wait_until: (artist.created_at + 1.day)).perform_later(artist.id)
      when 25..168
        StudioNotificationJob.set(wait_until: (artist.created_at + 7.days)).perform_later(artist.id)
      when 169..336
        StudioNotificationJob.set(wait_until: (artist.created_at + 14.days)).perform_later(artist.id)
      end
    end
    puts 'Finishing scheduling artist complete profile reminders'
  end
end
