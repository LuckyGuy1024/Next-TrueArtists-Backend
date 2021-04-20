class Article < ApplicationRecord
  enum status: {
    draft: 'draft',
    published: 'published',
    flagged: 'flagged'
  }

  searchkick word_start: %i[title page_title slug meta_description introduction content tag_list]

  belongs_to :user
  belongs_to :category
  extend FriendlyId
  friendly_id :slug_candidates, use: :history

  validates_uniqueness_of :title, :page_title
  validates :meta_description, :introduction, :content, :status, presence: true

  has_one_attached :image

  validates :image, size: { less_than: 10.megabytes, message: 'is not given between size' }

  before_validation :assign_status, only: %i[create update]
  before_validation :import_tag_list, only: %i[create update]

  def slug_candidates
    [
      :title,
      %i[title id]
    ]
  end

  def assign_status
    self.status = Article.statuses[status] || Article.statuses[:draft]
  end

  def import_tag_list
    self.tag_list = JSON.parse(tag_list).uniq.join(',') if tag_list_changed?
  end
end
