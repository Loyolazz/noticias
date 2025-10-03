class CommentsController < ApplicationController
  before_action :require_login

  def create
    commentable = find_commentable
    @comment = commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.locale = I18n.locale.to_s

    if @comment.save
      redirect_to commentable, notice: t('flash.comment_submitted')
    else
      redirect_to commentable, alert: @comment.errors.full_messages.to_sentence
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    if params[:news_id]
      News.friendly.find(params[:news_id])
    elsif params[:video_id]
      Video.friendly.find(params[:video_id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
