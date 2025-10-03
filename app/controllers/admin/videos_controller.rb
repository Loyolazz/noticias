module Admin
  class VideosController < BaseController
    before_action :set_video, only: %i[show edit update destroy]

    def index
      @videos = Video.ordered
    end

    def show; end

    def new
      @video = Video.new
      load_tags
    end

    def edit
      load_tags
    end

    def create
      @video = Video.new(video_params)
      @video.author = current_user

      if @video.save
        redirect_to admin_video_path(@video), notice: t('flash.video_created')
      else
        load_tags
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @video.update(video_params)
        redirect_to admin_video_path(@video), notice: t('flash.video_updated')
      else
        load_tags
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @video.destroy
      redirect_to admin_videos_path, notice: t('flash.video_deleted')
    end

    private

    def set_video
      @video = Video.friendly.find(params[:id])
    end

    def video_params
      params.require(:video).permit(:title_pt, :title_es, :description_pt, :description_es, :url, tag_ids: [])
    end

    def load_tags
      @tags = Tag.order(:name)
    end
  end
end
