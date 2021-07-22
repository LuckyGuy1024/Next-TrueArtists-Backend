module Legacy
  class Studio < Base
    self.abstract_class = true
    self.table_name = 'studios'
    connects_to database: { reading: :legacy, writing: :primary }

    def self.logger
      @logger ||=
        Logger.new(Rails.root.join('log', 'studios.log'))
    end

    def self.migrate
      ActiveRecord::Base.connected_to(role: :reading) do
        progress_bar = ProgressBar.new(Legacy::Studio.count)
        find_each do |studio|
          languages = studio.languages.to_a.map(&:name).join(',').presence
          specialty = studio.specialities.to_a.map(&:name).join(',').presence
          ActiveRecord::Base.connected_to(role: :writing) do
            new_studio = ::Studio.find_or_initialize_by(email: studio.email)
            new_studio.id = studio.id
            new_studio.user_id = studio.user_id
            new_studio.name = studio.name
            new_studio.bio = studio.description
            new_studio.languages = languages
            new_studio.website_url = studio.website
            new_studio.facebook_url = studio.facebook
            new_studio.twitter_url = studio.twitter
            new_studio.lat = studio.lat
            new_studio.lon = studio.lon
            new_studio.street_address = studio.address
            new_studio.city = studio.city
            new_studio.state = studio.address_state
            new_studio.zip_code = studio.zip_code
            new_studio.country = studio.country
            new_studio.appointment_only = studio.appointment_only
            # new_studio.specialty = specialty
            new_studio.accepted_payment_methods = studio.payment_methods
            new_studio.phone_number = studio.telephone
            new_studio.slug = studio.slug
            
            new_artist.status = if studio.admin_approved && (studio.city.present? || studio.country.present?)
                                  'approved'
                                else
                                  'pending'
                                end

            if new_studio.save(validate: false) && studio.logo_file_name
              new_studio.avatar.purge if new_studio.avatar.present?

              image_file_name = studio.logo_file_name
              image_extension = File.extname(image_file_name)
              optimized_file_name = new_studio.name.slugorize.escape

              new_file_name = "#{optimized_file_name}#{image_extension}"

              s3_image_url = "https://s3.amazonaws.com/trueartists_production/logos/#{studio.id}/original/#{image_file_name.escape}"
              new_studio.avatar.attach(key: "studios/#{new_studio.id}/logo/#{new_file_name}",
                                       io: URI.open(s3_image_url),
                                       filename: new_file_name,
                                       content_type: studio.logo_content_type)

            end
            progress_bar.increment
          rescue StandardError => e
            logger.error("Studio[#{studio.id}] \n\n -------------------- #{e.inspect}\n\n\n")
          end
        end
      end
    end
  end
end
