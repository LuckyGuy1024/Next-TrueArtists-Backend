# frozen_string_literal: true

namespace :send_tattoo_upload_email do
  task reminder: :environment do
    puts 'Starting Studio Tattoo Image Reminder'
    Studio.where(status: 'pending').find_each do |studio|
      StudioMailer.upload_new_images(studio).deliver_now
    end
    puts 'Finishing Studio Tattoo Image Reminder'

    puts 'Starting Artist Tattoo Image Reminder'
    Artist.where(status: 'pending').find_each do |artist|
      ArtistMailer.upload_new_images(artist).deliver_now
    end
    puts 'Finishing Artist Tattoo Image Reminder'
  end
end
