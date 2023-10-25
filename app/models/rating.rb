class Rating < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :rater, class_name: 'User'

  validates :rating, presence: true

  scope :high, -> { where('rating >= 4') }
end
