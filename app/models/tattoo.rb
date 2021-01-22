class Tattoo < ApplicationRecord
  include AssetExtension
  belongs_to :studio
  belongs_to :artist
end
