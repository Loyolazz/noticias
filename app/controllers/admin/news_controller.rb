module Admin
  class NewsController < BaseController
    before_action :set_news, only: %i[show edit update destroy]

    def index
      @news = News.ordered
    end

    def show; end

    def new
      @news = News.new
      load_tags
    end

    def edit
      load_tags
    end

    def create
      @news = News.new(news_params)
      @news.author = current_user

      if @news.save
        redirect_to admin_news_path(@news), notice: t('flash.news_created')
      else
        load_tags
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @news.update(news_params)
        redirect_to admin_news_path(@news), notice: t('flash.news_updated')
      else
        load_tags
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @news.destroy
      redirect_to admin_news_index_path, notice: t('flash.news_deleted')
    end

    private

    def set_news
      @news = News.friendly.find(params[:id])
    end

    def news_params
      params.require(:news).permit(:title_pt, :title_es, :body_pt, :body_es, tag_ids: [])
    end

    def load_tags
      @tags = Tag.order(:name)
    end
  end
end
