# frozen_string_literal: true

class Category < ApplicationRecord
  searchkick

  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged history]

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
