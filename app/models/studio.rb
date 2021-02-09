# frozen_string_literal: true

class Studio < ApplicationRecord
  include AssetExtension
  belongs_to :user
  has_many :studio_invites, dependent: :destroy
  has_many :studio_artists
  has_many :artists, through: :studio_artists
  has_one_attached :avatar
  has_one_attached :hero_banner

  validates :avatar, :hero_banner, size: { less_than: 10.megabytes, message: 'is not given between size' }

  validates :email, presence: true, on: create
  validates :user_id, uniqueness: true

  after_commit :upgrade_user_role, on: :create

  # send email to artist after accepting them
  # to acknowlege that they have been added to studio

  def add_artist(artist_id)
    studio_artists.create(artist_id: artist_id)
  end

  private

  def upgrade_user_role
    user.assign_role(User.roles[:studio])
  end
end
