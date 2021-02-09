# frozen_string_literal: true

class Artist < ApplicationRecord
  include AssetExtension
  belongs_to :user
  has_many :tattoos
  has_many :studio_artists
  has_many :studios, through: :studio_artists
  has_one_attached :avatar
  has_one_attached :hero_banner

  validates :avatar, :hero_banner, size: { less_than: 10.megabytes, message: 'is not given between size' }
  validates :user_id, uniqueness: true

  after_commit :upgrade_user_role, on: :create

  def upgrade_user_role
    user.assign_role(User.roles[:artist])
  end
end
