#RAILS_ENV=staging nohup bundle exec rails import:legacy_data --trace
namespace :import do
  task legacy_data: :environment do
    puts "Starting Tattoo Style"
    Legacy::TattooStyle.migrate
    puts "Finished Tattoo Style"

    puts "Starting Categories"
    Legacy::Category.migrate
    puts "Finished Categories"

    puts "Starting Users"
    Legacy::User.migrate
    puts "Finishing Users"

    puts "Starting Artists"
    Legacy::Artist.migrate
    puts "Finishing Artists"

    puts "Starting Studios"
    Legacy::Studio.migrate
    puts "Finishing Studios"

    puts "Starting Studio Artists"
    Legacy::StudioArtist.migrate
    puts "Finishing Studio Artists"
  end
end
