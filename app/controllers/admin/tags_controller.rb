module Admin
  class TagsController < BaseController
    before_action :set_tag, only: %i[edit update destroy]

    def index
      @tags = Tag.order(:locale, :name)
      @tag = Tag.new
    end

    def create
      @tag = Tag.new(tag_params)

      if @tag.save
        redirect_to admin_tags_path, notice: t('flash.tag_created')
      else
        @tags = Tag.order(:locale, :name)
        render :index, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @tag.update(tag_params)
        redirect_to admin_tags_path, notice: t('flash.tag_updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @tag.destroy
      redirect_to admin_tags_path, notice: t('flash.tag_deleted')
    end

    private

    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name, :locale)
    end
  end
end
