module Legacy
  class Artist < Base
    def self.migrate
      connected_to(role: :reading) do
        find_each do |artist|
          # find user
          connected_to(role: :writing) do
            user = ::User.find_by(id: artist.user_id)
            next unless user

            new_artist = ::Artist.find_or_initialize_by(user_id: artist.user_id)
            new_artist.name = "#{user.first_name} #{user.last_name}"
            new_artist.bio = artist.bio
            new_artist.slug = artist.slug
            new_artist.licensed = artist.licensed
            new_artist.cpr_certified = artist.cpr_certified
            new_artist.years_of_experience = artist.years_of_experience
            new_artist.website = artist.website
            new_artist.facebook_url = artist.facebook_page
            new_artist.twitter_url = artist.twitter_page
            new_artist.instagram_url = artist.instagram
            new_artist.phone_number = artist.phone_number
            new_artist.minimum_spend = artist.minimum_spend
            new_artist.price_per_hour = artist.hourly_rate
            new_artist.seeking_guest_spot = artist.seeking_guest_spot
            new_artist.state = artist.state
            new_artist.street_address = artist.address
            new_artist.city = artist.city
            new_artist.zip_code = artist.zip_code
            new_artist.lat = artist.lat
            new_artist.lon = artist.lon
            new_artist.styles = ::Style.where(name: artist.tattoo_styles.map(&:name))
            new_artist.specialty = artist.specialities.to_a.map(&:name).join(",")
            new_artist.phone_verified = artist.phone_verified
            new_artist.status = if artist.admin_approved
                                  'approved'
                                else
                                  'pending'
                                end

            new_artist.save

            if new_artist.save && artist.logo_file_name
              image = artist.logo_file_name
              ext = File.extname(image)
              image_original = CGI.unescape(image.gsub(ext, "_original#{ext}"))

              logo_url = "https://s3.amazonaws.com/trueartists_production/logos/#{artist.id}/original/#{image_original}"
              new_artist.avatar.attach(io: open(logo_url),
                                       filename: artist.logo_file_name,
                                       content_type: artist.logo_content_type)
            end
          end
        end
      end
    end
  end
end
