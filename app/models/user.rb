# frozen_string_literal: true

class User < ApplicationRecord
  enum status: {
    active: 'active',
    inactive: 'inactive',
    suspended: 'suspended',
    closed: 'closed'
  }

  enum role: {
    admin: 'admin',
    artist: 'artist',
    studio_manager: 'studio_manager',
    regular: 'regular'
  }

  require 'json_web_token'
  extend FriendlyId
  friendly_id :slug_candidates, use: :history

  acts_as_favoritor
  before_save :downcase_email
  has_secure_password

  has_one :artist, dependent: :destroy
  has_one :studio, dependent: :destroy
  has_many :articles, dependent: :destroy

  STRONG_PASSWORD = /(?=.*[a-zA-Z])(?=.*[0-9]).{6,10}/.freeze

  validates :role, presence: true
  validates :password, presence: true, format: { with: STRONG_PASSWORD }, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_confirmation_of :password_confirmation,
                            message: 'password does match confirmation',
                            on: :create

  after_initialize :assign_basic_role, if: :new_record?

  def slug_candidates
    [
      :full_name,
      %i[full_name id]
    ]
  end

  def assign_basic_role
    self.role = User.roles[:regular]
    self.status = User.statuses[:active]
  end

  def downcase_email
    self.email = email.strip.downcase
  end

  def reset_password_request
    auth_token = JsonWebToken.encode(user_id: id)

    UserMailer.password_reset_instructions(self, auth_token).deliver_now
  end

  def set_new_password(attrs)
    return unless attrs[:password] == attrs[:password_confirmation]

    update(password: attrs[:password])
  end

  def assign_role(role)
    update(role: User.roles[role.to_sym])
  end

  def admin?
    role == User.roles[:admin]
  end
end
