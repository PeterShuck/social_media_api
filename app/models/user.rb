class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :ratings_received, class_name: 'Rating', foreign_key: 'user_id', dependent: :destroy
  has_many :ratings_given, class_name: 'Rating', foreign_key: 'rater_id', dependent: :destroy
end
