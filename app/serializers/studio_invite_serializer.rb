class StudioInviteSerializer < ActiveModel::Serializer
  attributes :id,
             :studio,
             :artist,
             :accepted,
             :created_at

  def studio
    studio = Studio.find(object.studio_id)

    { id: studio.id, name: studio.name }
  end

  def artist
    artist = Artist.find(object.artist_id)

    { id: artist.id, name: artist.name }
  end
end
