class VideosController < ApplicationController
  before_action :set_video, only: :show

  def index
    @videos = Video.ordered
  end

  def show
    @comment = Comment.new
    @rating = logged_in? ? @video.ratings.find_or_initialize_by(user: current_user) : Rating.new
  end

  private

  def set_video
    @video = Video.friendly.find(params[:id])
  end
end
