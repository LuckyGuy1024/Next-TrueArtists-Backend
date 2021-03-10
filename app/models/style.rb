class Style < ApplicationRecord
  has_many :artist_styles
  has_many :artists, through: :artist_styles
  validates :name, presence: true, uniqueness: true
end
