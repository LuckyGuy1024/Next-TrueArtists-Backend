class StudioInvitePolicy < ApplicationPolicy
  attr_reader :user, :studio_invite

  def initialize(user, studio_invite)
    @user = user
    @studio_invite = studio_invite
  end

  def accept_studio_invite?
    user.admin? or user.artist.id == studio_invite.artist_id
  end

  def reject_studio_invite?
    user.admin? or user.artist.id == studio_invite.artist_id
  end

  def cancel_studio_invite?
    user.admin? or user.studio.id == studio_invite.studio_id
  end
end
