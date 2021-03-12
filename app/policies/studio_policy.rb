class StudioPolicy < ApplicationPolicy
  attr_reader :user, :studio

  def initialize(user, studio)
    @user = user
    @studio = studio
  end

  def update?
    user.admin? or user.id == studio.user_id
  end

  def remove_image?
    user.admin? or user.id == studio.user_id
  end

  def invite_artist?
    user.admin? or user.id == studio.user_id
  end

  def submit_for_review?
    user.admin? or user.id == studio.user_id
  end
end
