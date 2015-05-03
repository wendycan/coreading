class ArticlesController < ApplicationController
  def index
    @articles = Article.paginate(:page => params[:page])
  end

  def show
    @article = Article.find_by_id(params[:id])
  end

  def user_articles
    @articles = current_user.articles.paginate(:page => params[:page])
  end
end
