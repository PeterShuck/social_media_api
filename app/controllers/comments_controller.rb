class CommentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :comment_not_found

  def index
    @comments = post.comments # return only comments for this post

    render json: @comments
  end

  def show
    @comment = Comment.find(params[:id])
    render json: @comment
  end

  def create
    @comment = Comment.new
    @comment.message = params[:message]
    @comment.user = user
    @comment.post = post
    @comment.commented_at = DateTime.now
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { error: @comment.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    Comment.find(params[:id]).destroy

    head :no_content
  end

  private

  def comment_params
    params.require(:comment).permit(:message, :user)
  end

  def user
    begin
      return User.find_by(email: params[:user]) # email for the time being until we have authentication
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cannot find User for #{params[:user]}" }, status: :not_found
    end
  end

  def post
    begin
      return Post.find(params[:post_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cannot find parent Post" }, status: :not_found
    end
  end

  def comment_not_found
    render json: { error: "Cannot find Comment" }, status: :not_found
  end
end
