class NewsController < ApplicationController
  before_action :set_news, only: :show

  def index
    @news = News.search_by_term(params[:q])
  end

  def show
    @comment = Comment.new
    @rating = logged_in? ? @news.ratings.find_or_initialize_by(user: current_user) : Rating.new
  end

  private

  def set_news
    @news = News.friendly.find(params[:id])
  end
end
