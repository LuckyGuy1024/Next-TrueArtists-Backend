class QuickReply < ApplicationRecord
  belongs_to :owner, polymorphic: true
  validates :content, :name, presence: true
  validates :name, uniqueness: { scope: %i[owner_id owner_type] }

  def self.search(query)
    where("content LIKE :query OR
           category LIKE :query OR
           name LIKE :query",
          query: "%#{query}%")
  end
end
