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
                          []
                        end
  end

  def sorted_response
    github_responses.sort_by{ |h| h["most_recent_action"] }.reverse!
  end

  def user_not_found
      render json: { error: "Cannot find User" }, status: :not_found
  end
end
