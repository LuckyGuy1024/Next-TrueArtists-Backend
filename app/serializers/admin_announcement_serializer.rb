class AdminAnnouncementSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :user

  attributes :id,
             :title,
             :published_by,
             :published_on,
             :status

  def published_on
    object.created_at.strftime("%d-%m-%Y")
  end
end
