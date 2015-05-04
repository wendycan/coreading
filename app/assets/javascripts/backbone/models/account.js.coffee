class Coreading.Models.Account extends Backbone.Model
  defaults:
    email: ''
    password: true
    auth_token: ''
    unsync: true
    username: ''

  fetch_account: (opts)->
    success = opts.success
    _this = this
    $.ajax(
      url: '/users/current.json'
      success: (data, status, xhr)->
        data.unsync = false
        _this.set(data)
        if (success)
          success(data, status, xhr)
    )
