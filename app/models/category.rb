# frozen_string_literal: true

class Category < ApplicationRecord
  searchkick word_start: %i[name meta_description description]

  extend FriendlyId
  friendly_id :name, use: :history

  has_many :articles
  has_many :subcategories, foreign_key: :parent_id, class_name: 'Category'

  validates :name, :meta_description, :description, :status, presence: true
end
