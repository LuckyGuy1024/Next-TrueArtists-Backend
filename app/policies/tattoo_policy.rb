class TattooPolicy < ApplicationPolicy
  attr_reader :user, :tattoo

  def initialize(user, tattoo)
    @user = user
    @tattoo = tattoo
  end

  def update?
    user.admin? or user.id == if tattoo.artist
                                tattoo.artist.user_id
                              else
                                tattoo.studio.user_id
                              end
  end
end
