class ArtistPolicy < ApplicationPolicy
  attr_reader :user, :artist

  def initialize(user, artist)
    @user = user
    @artist = artist
  end

  def update?
    user.admin? or user.id == artist.user_id
  end

  def remove_image?
    user.admin? or user.id == artist.user_id
  end

  def submit_for_review?
    user.admin? or user.id == artist.user_id
  end
end
