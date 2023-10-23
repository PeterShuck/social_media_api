class UsersController < ApplicationController
  def index
    @users = User.all

    render json: @users
  end

  def show
    begin
      @user = User.find(params[:id])
      render json: @user
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cannot find User" }, status: :not_found
    end
  end
end
