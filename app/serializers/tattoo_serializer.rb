class TattooSerializer < ActiveModel::Serializer
  belongs_to :artist
  belongs_to :studio

  attributes :id,
             :styles,
             :categories,
             :placement,
             :color,
             :size
end
