Coreading.Common.rails_sync = (method, model, options)->
  params =
    beforeSend: (xhr)->
      if not options.noCSRF
        token = $('meta[name="csrf-token"]').attr('content')
        xhr.setRequestHeader('X-CSRF-Token', token) if token
      model.trigger('sync:start')
  Backbone.sync(method, model, _.extend(params, options))

Coreading.Common.api_sync = (method, model, options)->
  params =
    crossDomain: true
    headers: {
      'Auth-Token': Coreading.auth_token
    }
  Backbone.sync(method, model, _.extend(params, options))
