class QuickReply < ApplicationRecord
  belongs_to :owner, polymorphic: true
  validates :content, :name, presence: true
  validates :name, uniqueness: true 
end
