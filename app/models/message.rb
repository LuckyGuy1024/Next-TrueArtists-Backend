class Message < ApplicationRecord
  include AssetExtension

  validates :room_id, presence: true
end
