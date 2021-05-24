class StudioSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  has_many :artists
  has_many :tattoos

  attributes :id,
             :user_id,
             :name,
             :bio,
             :city,
             :state,
             :street_address,
             :zip_code,
             :country,
             :phone_number,
             :accepted_payment_methods,
             :appointment_only,
             :languages,
             :services,
             :email,
             :facebook_url,
             :twitter_url,
             :instagram_url,
             :website_url,
             :status,
             :slug,
             :accepting_guest_artist,
             :piercings,
             :cosmetic_tattoos,
             :vegan_ink,
             :wifi,
             :privacy_dividers,
             :wheelchair_access,
             :parking,
             :lgbt_friendly,
             :price_per_hour,
             :avatar,
             :hero_banner,
             :working_hours,
             :has_social_profiles,
             :has_tattoo_gallery,
             :has_avatar

  def avatar
    if object.avatar.attached?
      {
        id: object.avatar.id,
        image_url: ENV['HOST'] + rails_blob_path(object.avatar, only_path: true),
        name: object.avatar.filename,
        dimensions: ActiveStorage::Analyzer::ImageAnalyzer.new(object.avatar).metadata,
        status: object.avatar.status
      }
    end
  end

  def hero_banner
    if object.hero_banner.attached?
      {
        id: object.hero_banner.id,
        image_url: ENV['HOST'] + rails_blob_path(object.hero_banner, only_path: true),
        name: object.hero_banner.filename,
        dimensions: ActiveStorage::Analyzer::ImageAnalyzer.new(object.hero_banner).metadata,
        status: object.hero_banner.status
      }
    end
  end

  def working_hours
    [
      {
        id: 1,
        day: 'Monday',
        opened: object.monday,
        from: format_time(object.monday_start),
        to: format_time(object.monday_end)
      },
      {
        id: 2,
        day: 'Tuesday',
        opened: object.tuesday,
        from: format_time(object.tuesday_start),
        to: format_time(object.tuesday_end)
      },
      {
        id: 3,
        day: 'Wednesday',
        opened: object.wednesday,
        from: format_time(object.wednesday_start),
        to: format_time(object.wednesday_end)
      },
      {
        id: 4,
        day: 'Thursday',
        opened: object.thursday,
        from: format_time(object.thursday_start),
        to: format_time(object.thursday_end)
      },
      {
        id: 5,
        day: 'Friday',
        opened: object.friday,
        from: format_time(object.friday_start),
        to: format_time(object.friday_end)
      },
      {
        id: 6,
        day: 'Saturday',
        opened: object.saturday,
        from: format_time(object.saturday_start),
        to: format_time(object.saturday_end)
      },
      {
        id: 7,
        day: 'Sunday',
        opened: object.sunday,
        from: format_time(object.sunday_start),
        to: format_time(object.sunday_end)
      }
    ]
  end

  def format_time(time)
    return nil unless time

    time.strftime("%I:%M %p")
  end
end
