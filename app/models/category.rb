# frozen_string_literal: true

class Category < ApplicationRecord
  searchkick word_start: %i[name meta_description description]

  extend FriendlyId
  friendly_id :slug_candidates, use: :history

  has_many :articles
  has_many :subcategories, foreign_key: :parent_id, class_name: 'Category'

  validates :name, :meta_description, :description, :status, presence: true

  def slug_candidates
    [
      :name,
      %i[name id]
    ]
  end
end
