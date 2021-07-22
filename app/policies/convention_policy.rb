class ConventionPolicy < ApplicationPolicy
  attr_reader :user, :convention

  def initialize(user, convention)
    @user = user
    @convention = convention
  end

  def submit_for_review?
    user.admin? or user.id == convention.created_by
  end

  def update?
    user.admin? or user.id == convention.created_by
  end
end
