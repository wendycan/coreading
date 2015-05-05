class UsersController < ApplicationController
  def current
    @user = current_user
  end

  def group
    @groups = current_user.groups
  end

  def articles
    @articles = current_user.articles.paginate(:page => params[:page])
  end
end
