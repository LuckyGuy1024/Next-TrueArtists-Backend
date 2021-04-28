class Client< ApplicationRecord
  belongs_to :artist, optional: true
  belongs_to :studio, optional: true
  validates :name, :email, :phone_number, presence: true
end
