class StudioInvite < ApplicationRecord
  belongs_to :studio

  validates :studio_id, :invite_code, presence: true
  validates_presence_of :phone_number, unless: :email?
  validates_presence_of :email, unless: :phone_number?

  before_validation :generate_invite_code, on: :create

  def invite_artist_to_studio
    artist = if email.present?
               Artist.joins(:user).find_by({ users: { email: email } })
             else
               Artist.find_by(phone_number: phone_number)
             end

    if already_invited?
      StudioMailer.artist_invite_reminder(self).deliver_now
    else
      self.artist_id = artist&.id

      send_invitation if save
      self
    end
  end

  def already_invited?
    if email.present?
      StudioInvite.where(email: email)
    else
      StudioInvite.where(phone_number: phone_number)
    end.any?
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

  # send email to artist after accepting them
  # to acknowledge that they have been added to studio
  def accept!(artist_id)
    if studio.add_artist(artist_id)
      update(accepted: true, artist_id: artist_id)

      StudioMailer.confirm_adding_artist(email, studio.name).deliver_now
    else
      errors.full_messages
    end
  end
end
