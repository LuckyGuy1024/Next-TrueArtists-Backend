class Page < ApplicationRecord
  searchkick word_start: %i[title content]

  extend FriendlyId
  friendly_id :slug, use: %i[slugged history finders]

  validates_uniqueness_of :title
  validates :content, :title, presence: true
end
