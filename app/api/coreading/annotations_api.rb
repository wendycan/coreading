module Coreading
  class Annotation < Grape::API
    resource :annotations do
      desc 'Get all annotations'
      get do
        authenticate!
        annotations = current_user.annotations.where(article_id: params[:article_id])
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
