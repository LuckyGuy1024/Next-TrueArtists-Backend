class StudioInvite < ApplicationRecord
  belongs_to :studio
  belongs_to :artist

  validates :studio_id, :invite_code, :email, presence: true

  before_validate :generate_invite_code, on: :create
  after_transaction :send_invite_email, on: :create

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
  end
end
