class PostsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :post_not_found

  def index
    @posts = Post.all

    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  def create
    @post = Post.new
    @post.title = params[:title]
    @post.body = params[:body]
    @post.user = user
    @post.posted_at = DateTime.now
    if @post.save
      render json: @post, status: :created
    else
      render json: { error: @post.errors }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :user)
  end

  def user
    begin
      return User.find_by(email: params[:user]) # email for the time being until we have authentication
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cannot find User for #{params[:user]}" }, status: :not_found
    end
  end

  def post_not_found
    render json: { error: "Cannot find Post" }, status: :not_found
  end
end
