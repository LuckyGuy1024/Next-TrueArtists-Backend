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
    state :publish

    event :publish do
      transitions from: %i[draft], to: :published
    end
  end

  belongs_to :user, class_name: 'User', foreign_key: :published_by
  # has_many_attached :attachments

  validates :title, uniqueness: true
  validates :title, :content, :recipients, :status, presence: true

  cache_index :title, unique: true

  after_create :send_announcement
  after_update :send_announcement

  def send_announcement
    return if publish?
    perform_at = send_now? ? Time.zone.now : publish_on
    AnnouncementJob.set(wait_until: perform_at).perform_later(self)
  end
end
