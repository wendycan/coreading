module Coreading
  class Articles < Grape::API
    resource :articles do
      desc 'Get all articles'
     
      post do
        authenticate!
        article = Article.new()
        article.title = params[:title]
        article.body = params[:body]
        article.path_type = 'online'

        if article.save
          article
        else
          {errors: 'article create failed', status: 422}
        end
      end
    end
  end
end
