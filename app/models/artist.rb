# frozen_string_literal: true

class Artist < ApplicationRecord
  include AssetExtension
  belongs_to :user
  # belongs_to :studio
  has_many :tattoos
  has_one_attached :avatar
  has_one_attached :hero_banner

  validates :avatar, :hero_banner, size: { less_than: 10.megabytes, message: 'is not given between size' }

  validates :user_id, uniqueness: true
end
