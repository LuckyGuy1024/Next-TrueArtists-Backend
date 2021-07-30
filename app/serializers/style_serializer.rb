class StyleSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar


  def image
    if object.avatar.attached?
      {
        id: object.avatar.id,
        image_url: asset_blob_url(object.avatar),
      }
    end
  end
end
