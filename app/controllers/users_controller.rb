class UsersController < ApplicationController
  def current
    @user = current_user
  end

  def group
    @groups = current_user.groups
  end
end
