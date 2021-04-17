class Style < ApplicationRecord
  extend FriendlyId

  has_many :artist_styles
  has_many :artists, through: :artist_styles
  validates :name, presence: true, uniqueness: true

  friendly_id :name, use: %i[slugged history finders]
end
