class StudioInvite < ApplicationRecord
  belongs_to :studio

  validates :studio_id, :invite_code, presence: true

  validates_presence_of :phone_number, unless: :email?
  validates_presence_of :email, unless: :phone_number?

  before_validation :generate_invite_code, on: :create
  after_save :send_invite_email, if: :email?
  after_save :send_invite_phone, if: :phone_number?

  def generate_invite_code
    return unless invite_code.blank?

    record = true

    while record
      random = "TA#{Array.new(11) { rand(9) }.join}"
      record = self.class.where(invite_code: random).first
    end

    self.invite_code = random
  end

  def send_invite_email
    StudioMailer.artist_studio_invite(self).deliver_now
  end

  def send_invite_phone; end
end
