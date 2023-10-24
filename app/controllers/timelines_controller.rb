class TimelinesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found
  before_action :lookup_user, only: [:get_timeline_for_user]


  def get_timeline_for_user
    if @user.blank?
      render json: { error: "Cannot find User" }, status: :not_found
    else
      render json: sorted_response
    end
  end

  protected

  def lookup_user
    @user = User.find(params[:user_id])
  end

  def github_responses
    @github_responses = begin
                          @user.merged_pull_requests + @user.pushed_commits + @user.new_repositories + @user.opened_pull_requests
                        rescue NoMethodError => e
                          Rails.logger.error e
                          Rails.logger.info "The GitHub API rate limit has likely been exceeded"
                          # We should return something to the user of the API to let them know what happened
                          [{ "media_type" => "github_error", "error" => "The GitHub API rate limit has been exceeded", "most_recent_action" => DateTime.now }]
                        end
  end

  def comments
    @user.comments.map do |comment|
      post_author = comment.post.user
      { "media_type" => "commented_on_post", "id" => comment.id, "post_id" => comment.post_id, "post_author" => post_author.name, "post_author_average_rating" => post_author.average_rating, "most_recent_action" => comment.commented_at }
    end
  end

  def posts
    @user.posts.map do |post|
      { "media_type" => "new_post", "id" => post.id, "title" => post.title, "number_of_comments" => post.number_of_comments, "most_recent_action" => post.posted_at }
    end
  end

  def high_ratings
    @user.ratings.high.map do |rating|
      { "media_type" => "passed_four_stars", "id" => rating.id, "user_average_rating" => rating.user.average_rating, "most_recent_action" => rating.rated_at }
    end
  end

  def sorted_response
    (github_responses + comments + posts + high_ratings).sort_by{ |h| h["most_recent_action"] }.reverse!
  end

  def user_not_found
      render json: { error: "Cannot find User" }, status: :not_found
  end
end
