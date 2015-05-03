class AnnotationsController < ApplicationController
 def index
    @annotations = Annotation.paginate(:page => params[:page])
  end

  def show
    @annotation = Annotation.find_by_id(params[:id])
  end
end
