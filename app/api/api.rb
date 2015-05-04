Dir["#{Rails.root}/app/api/coreading/*.rb"].each { |file| require file }

class Api < Grape::API
  #api
  version 'v1', using: :path
  format :json
  default_format :json
  desc 'Return version info'
  get do
    {version: '1'}
  end

  helpers do
    def current_user
      @current_user ||= locate_user
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless current_user
      error!('400 Not found', 400) unless current_user.editable
    end

    def locate_user
      token = params['auth_token'] || headers['Auth-Token']
      User.find_by(authentication_token: token) if token.present?
    end

    def create_annotation
      # create article
      annotation = Annotation.new()
      annotation.quote = params[:quote]
      annotation.text = params[:text]
      annotation.range = params[:range]
      annotation.tag = params[:tag]
      annotation.user_id = @current_user.id
      if annotation.save
        {status: 201}
      else
        {errors: 'annotation create failed', status: 422}
      end
    end

    def update_annotation
      annotation = Annotation.find(params[:id])
      annotation.quote = params[:quote]
      annotation.text = params[:text]
      annotation.range = params[:range]
      annotation.tag = params[:tag]
      if annotation.save
        {status: 200}
      else
        {errors: 'annotation update failed', status: 422}
      end
    end

    def delete_annotation
      annotation = Annotation.find(params[:id])
      annotation.destroy!
      {status: 204}
    end
  end

  mount Coreading::Annotation

end