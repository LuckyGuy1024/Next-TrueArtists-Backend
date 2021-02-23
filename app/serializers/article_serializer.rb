class ArticleSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :page_title,
             :slug,
             :meta_description,
             :introduction,
             :content,
             :tags,
             :status

  def tags
    return [] if object.tag_list.nil?

    object.tag_list.split(',')
  end
end
