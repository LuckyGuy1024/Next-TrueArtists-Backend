class TattooSerializer < ActiveModel::Serializer
  belongs_to :artist
  belongs_to :tattoos
  attributes :id,
             :styles,
             :category,
             :placement,
             :color,
             :size
end
