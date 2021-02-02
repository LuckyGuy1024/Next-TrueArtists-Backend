class StudioInvite < ApplicationRecord
  belongs_to :studio

  validates :studio_id, :invite_code, presence: true
  validates_presence_of :phone_number, unless: :email?
  validates_presence_of :email, unless: :phone_number?

  before_validation :generate_invite_code, on: :create

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
end
