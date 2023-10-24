class Comment < ApplicationRecord
  include Authored
  belongs_to :post

  def as_json(options={})
    options[:methods] = %i(author author_average_rating)
    super
  end
end
