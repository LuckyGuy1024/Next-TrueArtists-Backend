# frozen_string_literal: true

class Artist < ApplicationRecord
  include AssetExtension
  belongs_to :user
  # belongs_to :studio
  has_many :tattoos

  validates :user_id, uniqueness: true
end
