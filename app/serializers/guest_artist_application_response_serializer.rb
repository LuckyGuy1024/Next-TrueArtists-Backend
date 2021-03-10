class GuestArtistApplicationResponseSerializer < ActiveModel::Serializer
  belongs_to :guest_artist_application
  attributes :id,
             :message
end
