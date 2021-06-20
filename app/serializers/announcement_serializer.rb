class AnnouncementSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :user
# has_many :attachments

  attributes :id,
             :title,
             :content,
             :send_when,
             :send_now ,
             :recipients,
             :custom_emails,
             :published_by,
             :published_on,
             :status

  def published_on
    object.created_at.strftime("%d-%m-%Y")
  end
end
