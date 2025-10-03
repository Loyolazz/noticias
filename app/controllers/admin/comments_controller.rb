module Admin
  class CommentsController < BaseController
    before_action :set_comment, only: %i[update]

    def index
      @comments = Comment.pending.order(created_at: :asc)
    end

    def update
      case params[:status]
      when 'approved'
        @comment.approve!
        notice = t('flash.comment_approved')
      when 'rejected'
        @comment.reject!
        notice = t('flash.comment_rejected')
      else
        notice = t('flash.comment_not_changed')
      end

      redirect_to admin_comments_path, notice: notice
    end

    private

    def set_comment
      @comment = Comment.find(params[:id])
    end
  end
end
