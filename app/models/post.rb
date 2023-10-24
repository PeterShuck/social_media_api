class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user

  def number_of_comments
    comments.length
  end

  def author
    user.name
  end

  def author_average_rating
    user.average_rating
  end
end
