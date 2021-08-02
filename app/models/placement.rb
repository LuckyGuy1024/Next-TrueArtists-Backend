class Placement < ApplicationRecord
  OPTIONS = ['Arm', 'Ankle', 'Back', 'Ear', 'Calf', 'Chest',
             'Elbow', 'Foot', 'Forearm',
             'Hand', 'Hip', 'Knee', 'Neck', 'Ribs', 'Shin',
             'Shoulder', 'Sternum', 'Stomach', 'Thigh', 'Throat', 'Lower Leg', 'Wrist']

  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]

  has_many :tattoos
  has_one_attached :avatar

  validates :name, presence: true, uniqueness: true

  def self.find_all_cached
    Rails.cache.fetch('placements') do
      Placement.with_attached_avatar.to_a
    end
  end
end
