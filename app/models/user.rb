class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :ratings, class_name: 'Rating', foreign_key: 'user_id', dependent: :destroy
  has_many :ratings_given, class_name: 'Rating', foreign_key: 'rater_id', dependent: :destroy

  def pushed_commits
    return [] unless github_response.present?
    github_response.select { |event| event.type == "PushEvent"}&.map{ |e| { "media_type" => "pushed_commits", "number_of_commits" => e.payload.size, "repository" => e.repo.name, "most_recent_action" => e.created_at.to_datetime } }
  end

  def opened_pull_requests
    return [] unless github_response.present?
    github_response.select { |event| event.type == "PullRequestEvent" && event.payload.action == "opened" }&.map{ |e| { "media_type" => "opened_pr", "pr_number" => e.payload.number, "repository" => e.repo.name, "most_recent_action" => e.created_at.to_datetime } }
  end

  def merged_pull_requests
    return [] unless github_response.present?
    github_response.select { |event| event.type == "PullRequestEvent" && event.payload.action == "closed" && event.payload }&.map{ |e| { "media_type" => "merged_pr", "pr_number" => e.payload.number, "repository" => e.repo.name, "most_recent_action" => e.created_at.to_datetime } }
  end

  def new_repositories
    return [] unless github_response.present?
    github_response.select { |event| event.type == "CreateEvent" && event.payload.ref_type == "repository" }&.map{ |e| { "media_type" => "new_repo", "repository" => e.repo.name, "most_recent_action" => e.created_at.to_datetime } }
  end

  protected

  def github_response
    return nil unless github_username.present?
    response = Connection.third_party_api.get do |req|
      req.url "https://api.github.com/users/#{github_username}/events/public"
    end

    JSON.parse(response.body, object_class: OpenStruct)
  end
end
