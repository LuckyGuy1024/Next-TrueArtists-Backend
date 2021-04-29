module Legacy
  class Studio < Base
    def self.migrate
      connected_to(role: :reading) do
        find_each do |studio|
          connected_to(role: :writing) do
            new_studio = ::Studio.find_or_initialize_by(email: studio.email)
            new_studio.user_id = studio.user_id
            new_studio.name = studio.name
            new_studio.bio = studio.description
            new_studio.website_url = studio.website
            new_studio.facebook_url = studio.facebook
            new_studio.twitter_url = studio.twitter
            new_studio.lat = studio.lat
            new_studio.lon = studio.lon
            new_studio.languages = studio.languages
            new_studio.street_address = studio.address
            new_studio.city = studio.city
            new_studio.state = studio.state
            new_studio.zip_code = studio.zip_code
            new_studio.country = studio.country
            new_studio.appointment_only = studio.appointment_only
            new_studio.specialty = studio.specialities
            new_studio.accepted_payment_methods = studio.payment_methods
            new_studio.phone_number = studio.telephone
            new_studio.slug = studio.slug
            new_studio.status = if studio.admin_approved
                                  'approved'
                                else
                                  'pending'
                                end

            new_studio.save

            if new_studio.save && studio.logo_file_name
              image = studio.logo_file_name
              ext = File.extname(image)
              image_original = CGI.unescape(image.gsub(ext, "_original#{ext}"))

              logo_url = "https://s3.amazonaws.com/trueartists_production/logos/#{studio.id}/original/#{image_original}"
              new_studio.avatar.attach(io: open(logo_url),
                                       filename: studio.logo_file_name,
                                       content_type: studio.logo_content_type)
            end
          end
        end
      end
    end
  end
end
