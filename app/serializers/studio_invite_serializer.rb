class StudioInviteSerializer < ActiveModel::Serializer
  belongs_to :studio
  belongs_to :artist

  attributes :id,
             :accepted,
             :created_at

end
