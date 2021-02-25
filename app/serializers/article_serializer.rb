class ArticleSerializer < ActiveModel::Serializer
  attributes :id,
             :category_id,
             :title,
             :page_title,
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
