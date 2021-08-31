class QuickReply < ApplicationRecord
  belongs_to :owner, polymorphic: true
  validates :content, :name, presence: true
  validates :name, uniqueness: true


  def self.search(query)
    where("content LIKE :query OR
           category LIKE :query OR
           name LIKE :query",
           query: "%#{query}%")
  end
end
