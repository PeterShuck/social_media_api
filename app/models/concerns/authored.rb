module Authored
  extend ActiveSupport::Concern

  included do
    belongs_to :user
  end

  def author
    user.name
  end

  def author_average_rating
    user.average_rating
  end
end
