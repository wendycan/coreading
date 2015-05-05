module Coreading
  class Groups < Grape::API
    resource :groups do
      desc 'Get all annotations'

      route_param :id, requirements: /[^\/]+/ do
        # get do
        #   annotation = current_user.annotations.find(params[:id])
        #   JSON.parse annotation.to_json(:include => :user)
        # end

        put 'add_user' do
          authenticate!
          group = Group.find(params[:id])
          if group.admin_id != current_user.id
            error!('401 Unauthorized', 401)
          end
          user = User.where(username: params[:username])[0]
          if !user
            error!('404 Not found', 404)
          end
          if user.groups.length > 0 && user.groups.find(group.id)
            error!('409 Conflict', 409)
          end
          Usergroup.create(:group => group, :user => user)
          group
        end

        put 'remove_user' do
          authenticate!
          group = Group.find(params[:id])
          if group.admin_id != current_user.id
            error!('401 Unauthorized', 401)
          end

          user = User.where(username: params[:username])[0]

          if !user
            error!('404 Not found', 404)
          end

          if user.id == group.admin_id
            error!('403 Forbidden', 403)
          end

          if user.groups.length <= 0 || !user.groups.find(group.id)
            error!('404 Not found', 404)
          end
          
          Usergroup.where(group_id: group.id, user_id: user.id)[0].delete
          group
        end
      end

    end
  end
end
