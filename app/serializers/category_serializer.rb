class CategorySerializer < ActiveModel::Serializer
  has_many :articles
  has_many :subcategories

  attributes :id,
             :name,
             :meta_description,
             :status
end
