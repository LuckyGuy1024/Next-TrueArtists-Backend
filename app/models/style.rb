class Style < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]

  has_many :artist_styles
  has_many :artists, through: :artist_styles
  has_one_attached :avatar

  validates :name, presence: true, uniqueness: true
end
