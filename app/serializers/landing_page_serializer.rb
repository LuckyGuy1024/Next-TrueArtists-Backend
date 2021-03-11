class LandingPageSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id,
             :page_key,
             :page_url,
             :page_title,
             :meta_description,
             :title,
             :content,
             :moved_to,
             :status,
             :avatar,
             :last_updated_by

  def last_updated_by
    object.user.full_name
  end

  def avatar
    if object.avatar.attached?
      {
        id: object.avatar.id,
        image_url: ENV['HOST'] + rails_blob_path(object.avatar, only_path: true),
        name: object.avatar.filename
      }
    end
  end
end
