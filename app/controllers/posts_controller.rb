class PostsController < ApplicationController

  def index
    @posts = Post.all

    render json: @posts
  end

  def show
    begin
      @post = Post.find(params[:id])
      render json: @post
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cannot find Post" }, status: :not_found
    end
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
      render json: { error: 'Unable to create post' }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def user
    begin
      return User.find_by(email: params[:email]) # email for the time being until we have authentication
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cannot find User for #{params[:email]}" }, status: :not_found
    end
  end
end
