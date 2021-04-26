class ArticleSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :category

  attributes :id,
             :category_id,
             :title,
             :slug,
             :page_title,
             :meta_description,
             :introduction,
             :content,
             :tags,
             :status,
             :image

  def tags
    return [] if object.tag_list.nil?

    object.tag_list.split(',')
  end

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
