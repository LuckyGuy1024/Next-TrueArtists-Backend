class LandingPage < ApplicationRecord
  include AASM
  searchkick
  enum status: {
    draft: 'draft',
    published: 'published',
    archived: 'archived'
  }
  has_one_attached :avatar
  belongs_to :user, class_name: 'User', foreign_key: 'last_updated_by'
  validates :page_key, :page_url, :page_title, :meta_description, :title, :content, presence: true
  validates :page_key, :page_url, :page_title, uniqueness: true

  aasm column: 'status' do
    state :pending, initial: true
    state :pending_approval
    state :approved
    state :rejected

    event :pending_review do
      transitions from: :pending, to: :pending_approval
    end

    event :approve, after_commit: :send_status_notification do
      transitions from: :pending_approval, to: :approved
    end

    event :reject, after_commit: :send_status_notification do
      transitions from: :pending_approval, to: :rejected
    end
  end
end
