require 'logger'
module Legacy
  class Artist < Base
    self.abstract_class = true
    self.table_name = 'artists'
    connects_to database: { reading: :legacy, writing: :primary }

    belongs_to :user, class_name: 'Legacy::User'
    has_many :artist_specialities, class_name: 'Legacy::ArtistSpeciality'
    has_many :specialities, through: :artist_specialities
    has_many :artist_languages, class_name: 'Legacy::Language'
    has_many :languages, through: :artist_languages
    has_many :tattoo_categories, class_name: 'Legacy::TattooCategory'
    has_many :categories, through: :tattoo_categories
    has_many :artist_services, class_name: 'Legacy::ArtistService'
    has_many :services, through: :artist_services
    has_many :artist_tattoo_styles, class_name: 'Legacy::ArtistTattooStyle'
    has_many :tattoo_styles, through: :artist_tattoo_styles

    def self.logger
      @logger ||=
        Logger.new(Rails.root.join('log', 'artists.log'))
    end

    def self.migrate
      ActiveRecord::Base.connected_to(role: :reading) do
        progress_bar = ProgressBar.new(Legacy::Artist.count)
          where("id = 1799").where(admin_approved: true).find_each do |artist|
          # find user
          tattoo_style_ids = artist.tattoo_style_ids
          specialty = artist.specialities.to_a.map(&:name).join(',')

          ActiveRecord::Base.connected_to(role: :writing) do
            user = ::User.find_by(id: artist.user_id)
            next unless user

            new_artist = ::Artist.find_or_initialize_by(id: artist.id, user_id: user.id)
            new_artist.name = user.full_name
            new_artist.bio = artist.bio
            new_artist.slug = artist.slug
            new_artist.licensed = artist.licensed
            new_artist.cpr_certified = artist.cpr_certified
            new_artist.years_of_experience = artist.years_of_experiance
            new_artist.website = artist.website
            new_artist.facebook_url = artist.facebook_page
            new_artist.twitter_url = artist.twitter_page
            new_artist.instagram_url = artist.instagram
            new_artist.phone_number = artist.phone_number
            new_artist.minimum_spend = artist.minimum_spend
            new_artist.price_per_hour = artist.hourly_rate
            new_artist.seeking_guest_spot = artist.seeking_guest_spot
            new_artist.state = artist.address_state
            new_artist.street_address = artist.address
            new_artist.city = artist.city
            new_artist.zip_code = artist.zip_code
            new_artist.country = artist.country
            # new_artist.lat = artist.lat
            # new_artist.lon = artist.lon
            # migrate this separately for each artist
            new_artist.style_ids = tattoo_style_ids
            new_artist.specialty = specialty.presence

            # phon verification does not exist in system
            # new_artist.phone_verified = artist.phone_verified
            new_artist.status = if artist.admin_approved && (artist.city.present? || artist.country.present?)
                                  'approved'
                                else
                                  'pending'
                                end
            if new_artist.save(validate: false)
              if artist.logo_file_name.present?
                image_file_name = artist.logo_file_name
                image_extension = File.extname(image_file_name)
                optimized_file_name = new_artist.name.slugorize.escape
                new_file_name = "#{optimized_file_name}#{image_extension}"
                s3_image_url = "https://s3.amazonaws.com/trueartists_production/logos/#{artist.id}/original/#{image_file_name.escape}"

                options = {
                  key: "artists/#{new_artist.id}/logo/#{new_file_name}",
                  io: URI.open(s3_image_url),
                  filename: new_file_name,
                  content_type: artist.logo_content_type
                }

                new_artist.avatar.purge if new_artist.avatar.present?

                new_artist.avatar.attach(options)
              end
            end
            progress_bar.increment
          end
        rescue StandardError => e
          logger.error("Artist[#{artist.id}] \n\n -------------------- #{e.inspect}\n\n\n")
        end
      end
    end
  end
end
