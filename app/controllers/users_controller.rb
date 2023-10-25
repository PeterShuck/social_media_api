class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  def index
    @users = User.all

    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  protected

  def user_not_found
    render json: { error: "Cannot find User" }, status: :not_found
  end
end
