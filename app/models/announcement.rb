# frozen_string_literal: true

class Announcement < ApplicationRecord
  include IdentityCache
  include AASM
 
  searchkick word_start: %i[title status]

  aasm column: 'status' do
    state :published, initial: true
    state :flagged

    event :publish do
      transitions from: %i[flagged], to: :published
    end

    event :flag do
      transitions from: %i[published], to: :flagged
    end
  end

  belongs_to :user, class_name: 'User', foreign_key: :published_by 
# has_many_attached :attachments

  #validates_uniqueness_of :title
  validates :title , :content, :recipients, :custom_emails, :status, presence: true

  cache_index :title, unique: true
end
