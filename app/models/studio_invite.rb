class StudioInvite < ApplicationRecord
  include AASM

  aasm column: 'status' do
    state :pending, initial: true
    state :accepted
    state :rejected
    state :cancelled

    event :accept do
      transitions from: :pending, to: :accepted
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    event :cancel do
      transitions from: :pending, to: :cancelled
      transitions from: :accepted, to: :cancelled
    end
  end

  belongs_to :studio
  belongs_to :artist, optional: true

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

    return create_new_user unless artist

    studio_invite = StudioInvite.where(artist_id: artist.id, studio_id: studio_id).first

    if already_invited? && studio_invite

      StudioMailer.artist_invite_reminder(studio_invite).deliver_now if artist.user.status == 'active'
      StudioMailer.new_artist_invite_reminder(studio_invite).deliver_now if artist.user.status == 'inactive'
      studio_invite
    else
      self.artist_id = artist&.id

      send_invitation(false) if save
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

  def send_invitation(new_user)
    if new_user
      StudioMailer.new_artist_studio_invite(self).deliver_now
    elsif email
      send_email_invitation if email
    end
    send_sms_invitation if phone_number
  end

  # send email to artist after accepting them
  # to acknowledge that they have been added to studio
  def accept_invite!(artist_id)
    if studio.add_artist(artist_id)
      update(status: 'accepted', artist_id: artist_id)

      StudioMailer.confirm_adding_artist(email, studio.name).deliver_now
    else
      errors.full_messages
    end
  end

  def cancel_invite!
    StudioMailer.cancel_studio_invite(email, studio.name).deliver_now if cancel!
  rescue AASM::InvalidTransition => e
    e.message
  end

  def create_new_user
    return unless save

    begin
      user = User.create!(email: email, password: invite_code, password_confirmation: invite_code)

      artist = user.build_artist unless user.id.nil?

      if artist&.save
        user.update(status: 'inactive')
        update(artist_id: user.artist.id)
        send_invitation(true)
        self
      else
        user.delete
      end
    rescue StandardError => e
      delete
      e.message
    end
  end
end
