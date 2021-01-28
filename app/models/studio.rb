# frozen_string_literal: true

class Studio < ApplicationRecord
  include AssetExtension
  has_many :studio_artists
  has_many :artists, through: :studio_artists

  def invite_artist(attrs)
    studio_invite = StudioInvite.find_or_initialize_by(email: attrs[:email],
                                                       studio_id: id)
    studio_invite.save
  end
end
