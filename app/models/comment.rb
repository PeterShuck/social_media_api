class Comment < ApplicationRecord
  include Authored
  belongs_to :post

  validates :message, presence: true

  def as_json(options={})
    options[:methods] = %i(author author_average_rating)
    super
  end
end
