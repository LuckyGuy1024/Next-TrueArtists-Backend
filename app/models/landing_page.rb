class LandingPage < ApplicationRecord
  include IdentityCache

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

  cache_index :page_key, unique: true
end
