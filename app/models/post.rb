class Post < ApplicationRecord
  include Authored
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  def as_json(options={})
    options[:methods] = %i(number_of_comments author author_average_rating)
    super
  end

  def number_of_comments
    comments.length
  end
end
