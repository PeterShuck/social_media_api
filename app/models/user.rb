class User < ApplicationRecord
  has_many :comments
  has_many :posts
  has_many :ratings_received, class_name: 'Rating', foreign_key: 'user_id'
  has_many :ratings_given, class_name: 'Rating', foreign_key: 'rater_id'
end
