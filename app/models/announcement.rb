# frozen_string_literal: true

class Announcement < ApplicationRecord
  RECIPIENTS = %w[
    admin
    artist
    studio_manager
    regular
    all
  ]
  include IdentityCache
  include AASM

  aasm column: 'status' do
    state :draft, initial: true
    state :published

    event :publish do
      transitions from: %i[draft], to: :published
    end
  end

  belongs_to :user, class_name: 'User', foreign_key: :published_by
  has_one_attached :image
  
  validates :title, uniqueness: true
  validates :title, :content, :status, presence: true
  validates_presence_of :publish_on, unless: :send_now?
  validates_presence_of :send_now, unless: :publish_on?
  validates_presence_of :recipients, unless: :custom_emails?
  validates_presence_of :custom_emails, unless: :recipients?


  cache_index :title, unique: true

  after_create :send_announcement
  after_update :send_announcement

  def send_announcement
    return if published?
    perform_at = send_now? ? Time.zone.now : publish_on
    AnnouncementJob.set(wait_until: perform_at).perform_later(self)
  end
end
