module Coreading
  class Annotation < Grape::API
    resource :annotations do
      desc 'Get all annotations'
      get do
        authenticate!
        article = Article.find(params[:article_id])
        annotations = []
        if article.public == 0
          annotations = article.annotations
        elsif article.public == 1
          group = Group.find(article.group_id)
          group.users.each do |u|
            annotations.push({
              username: u.username, annotations: u.annotations.where(article_id: params[:article_id])
            })
          end
        elsif
          annotations = current_user.annotations.where(article_id: params[:article_id])
        end
        #.order("created_at DESC").all
        annotations
      end

      route_param :id, requirements: /[^\/]+/ do
        get do
          authenticate!
          annotation = current_user.annotations.find(params[:id])
          JSON.parse annotation.to_json(:include => :user)
        end

        post do
          authenticate!
          create_annotation
        end

        put do
          authenticate!
          update_annotation
        end

        desc 'Delete a annotation'
        delete do
          authenticate!
          delete_annotation
        end
      end


      post do
        authenticate!
        create_annotation
      end
    end
  end
end
