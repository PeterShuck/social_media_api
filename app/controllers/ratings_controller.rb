class RatingsController < ApplicationController
  def index
    @ratings = user.ratings

    render json: @ratings
  end

  def show
    begin
    @rating = Rating.find(params[:id])
    render json: @rating
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cannot find Rating" }, status: :not_found
    end
  end

  def create
    @rating = Rating.new
    @rating.rating = params[:rating]
    @rating.user = user
    @rating.rater = rater
    @rating.rated_at = DateTime.now
    if @rating.save
      render json: @rating, status: :created
    else
      render json: { error: @rating.errors }, status: :unprocessable_entity
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:rating, :rater) # we need to find a way to get user here too
  end

  def user
    begin
      return User.find(params[:user_id]) # email for the time being until we have authentication
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cannot find User" }, status: :not_found
    end
  end

  def rater
    begin
      return User.find_by(email: params[:rater]) # email for the time being until we have authentication
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cannot find User for #{params[:rater]}" }, status: :not_found
    end
  end
end
