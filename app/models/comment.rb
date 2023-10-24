class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  def as_json(options={})
    options[:methods] = %i(author author_average_rating)
    super
  end

  def author
    user.name
  end

  def author_average_rating
    user.average_rating
  end
end
