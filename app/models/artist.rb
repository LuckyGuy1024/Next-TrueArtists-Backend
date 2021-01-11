class Artist < ApplicationRecord
  belongs_to :user
  belongs_to :studio
  has_many :tattoos
end
