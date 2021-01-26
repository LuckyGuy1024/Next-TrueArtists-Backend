# frozen_string_literal: true

class Studio < ApplicationRecord
  include AssetExtension
  has_many :studio_artists
  has_many :artists, through: :studio_artists

  validates :user_id, uniqueness: true

  def invite_artist(attrs)
    artist_id = if attrs[:email].present?
                  Artist.joins(:user).find_by({ users: { email: attrs[:email] } })
                else
                  Artist.find_by(phone_number: attrs[:phone_number])
                end

    studio_invite = StudioInvite.find_or_initialize_by(email: attrs[:email],
                                                       phone_number: attrs[:phone_number],
                                                       artist_id: artist_id.present? ? artist_id.id : nil,
                                                       studio_id: id)

    studio_invite.save
  end
end
