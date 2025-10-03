class RatingsController < ApplicationController
  before_action :require_login

  def create
    rateable = find_rateable
    @rating = rateable.ratings.find_or_initialize_by(user: current_user)

    if @rating.update(rating_params)
      redirect_to rateable, notice: t('flash.rating_saved')
    else
      redirect_to rateable, alert: @rating.errors.full_messages.to_sentence
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:value)
  end

  def find_rateable
    if params[:news_id]
      News.friendly.find(params[:news_id])
    elsif params[:video_id]
      Video.friendly.find(params[:video_id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
