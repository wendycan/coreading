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

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :body, :path_type, :pdf, :public, :group_id)
    end
end
