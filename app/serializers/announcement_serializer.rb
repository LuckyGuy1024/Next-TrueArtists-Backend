class AnnouncementSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :user
# has_many :attachments

  attributes :id,
             :title,
             :content,
             :send_now ,
             :recipients,
             :custom_emails,
             :published_by,
             :publish_on,
             :status
end
