class StudioInvite < ApplicationRecord
  belongs_to :studio

  validates :studio_id, :invite_code, presence: true
  validates_presence_of :phone_number, unless: :email?
  validates_presence_of :email, unless: :phone_number?

  before_validation :generate_invite_code, on: :create

  def add_studio_invite
    artist = find_artist(self)

    if studio_invite_present?(self)
      # send reminder email instead
      # studio_invite.send_invitation_reminder
    else
      self.artist_id = artist&.id

      send_invitation if save
      self
    end
  end

  def find_artist(attrs)
    if attrs[:email].present?
      Artist.joins(:user).find_by({ users: { email: attrs[:email] } })
    else
      Artist.find_by(phone_number: attrs[:phone_number])
    end
  end

  def studio_invite_present?(attrs)
    studio_invite = if attrs[:email].present?
                      StudioInvite.where(email: attrs[:email]).first
                    else
                      StudioInvite.where(phone_number: attrs[:phone_number]).first
                    end

    studio_invite.present?
  end

  def generate_invite_code
    return unless invite_code.blank?

    record = true

    while record
      random = "TA#{Array.new(11) { rand(9) }.join}"
      record = self.class.where(invite_code: random).first
    end

    self.invite_code = random
  end

  def send_email_invitation
    StudioMailer.artist_studio_invite(self).deliver_now
  end

  def send_sms_invitation; end

  def send_invitation
    send_email_invitation if email
    send_sms_invitation if phone_number
  end

  def add_artist_to_studio(artist_id)
    studio_artist = StudioArtist.find_or_initialize_by(
      artist_id: artist_id,
      studio_id: studio.id
    )

    update(accepted: true, artist_id: artist_id) if studio_artist.save
    studio_artist
  end
end
