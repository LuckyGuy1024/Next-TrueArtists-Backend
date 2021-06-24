class StudioInviteSerializer < ActiveModel::Serializer
  belongs_to :studio
  belongs_to :artist

  attributes :id,
             :status,
             :artist,
             :studio,
             :created_at

  def studio
    studio = object.studio

    { id: studio.id, name: studio.name }
  end

  def artist
    artist = object.artist

    { id: artist.id, name: artist.name }
  end
end
