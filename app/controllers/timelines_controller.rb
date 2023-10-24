class TimelinesController < ApplicationController

  def get_timeline_for_user
    user = User.find(params[:user_id])

    if user.blank?
      render json: { error: "Cannot find User" }, status: :not_found
    else
      render json: user.comments
    end
  end
end
