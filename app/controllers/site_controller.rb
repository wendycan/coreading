class SiteController < ApplicationController
  layout 'home', :only => [:index]

  def index
  end
end
