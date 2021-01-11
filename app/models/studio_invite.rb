class StudioInvite < ApplicationRecord
  belongs_to :studio
  belongs_to :artist
end
