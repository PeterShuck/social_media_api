class Rating < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :rater, class_name: 'User'

  validates :rating, numericality: { in: 0..5 }

  scope :high, -> { where('rating >= 4') }
end
