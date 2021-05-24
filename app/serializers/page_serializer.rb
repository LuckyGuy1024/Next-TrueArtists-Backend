class PageSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :slug,
             :content,
             :active,
             :parent_id
end
