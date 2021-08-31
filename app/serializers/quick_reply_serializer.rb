class QuickReplySerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :category,
             :content,
             :owner_type,
             :owner_id,
             :updated_at,
             :created_at
end
