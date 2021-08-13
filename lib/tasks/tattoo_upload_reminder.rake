# frozen_string_literal: true

namespace :tattoo_upload do
  task reminder: :environment do
    puts 'Starting Studio Tattoo Image Reminders'
    Studio.where(status: 'accepted').find_each do |studio|
      StudioMailer.upload_new_images(studio).deliver_now
    end
    puts 'Finishing Studio Tattoo Image Reminders'

    puts 'Starting Artist Tattoo Image Reminders'
    Artist.where(status: 'accepted').find_each do |artist|
      ArtistMailer.upload_new_images(artist).deliver_now
    end
    puts 'Finishing Artist Tattoo Image Reminders'
  end
end
