class AnnouncementSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :user

  attributes :id,
             :title,
             :content,
             :send_now,
             :recipients,
             :custom_emails,
             :published_by,
             :publish_on,
             :status,
             :image

  def image
    if object.image.attached?
      {
        id: object.image.id,
        image_url: ENV['HOST'] + rails_blob_path(object.image, only_path: true),
        name: object.image.filename,
        status: object.image.status
      }
    end
  end
end
