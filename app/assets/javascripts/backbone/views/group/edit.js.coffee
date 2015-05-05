Coreading.Views.Groups ||= {}

class Coreading.Views.Groups.GroupEditView extends Backbone.View
  el: '#main-content'

  events:
    'click #save-meta' : 'saveMeta'
    'click #add-user-btn' : 'addUser'
    'click #submit-add-user' : 'submitAddUser'
    'click .remove-user' : 'removeUser'
    'click #cancel-add-user' : 'cancelAddUser'

  initialize: (opts)->
    @account = new Coreading.Models.Account
    @opts = opts
    @fetchAccount =>
      console.log(opts)
      console.log(@account)
      @render(opts)

  fetchAccount: (success, error)->
    if @account.get('unsync')
      @account.fetch_account(
        success: (data)=>
          if success?
            success()
        error: ->
          if error?
            error()
      )

  render: (data)->
    meta = {
      title: data.title
      desc: data.desc
    }
    users = data.usernames
    articles = data.articles
    $('#edit-group').html _.template($('#t-edit-group').html())(group: meta)
    users.forEach (username)->
      $('#user-list').append _.template($('#t-user').html())(username: username)
    articles.forEach (article)->
      $('#articles-list').append _.template($('#t-article').html())(article: article)

  addUser: ()->
    $('#add-user-btn').hide()
    $('#add-user').html _.template($('#t-add-user-form').html())()

  submitAddUser: ->
    username = $('#username').val()
    if username.length < 1
      return
    $.ajax 
      url: "/api/v1/groups/#{@opts.id}/add_user"
      type: "PUT"
      data: 
        username: username
      headers:
        'Auth-Token': @account.get('auth_token')
      success: (data)->
        alertify.success("成功添加#{username}")
        $('#user-list').append _.template($('#t-user').html())(username: username)
        $('#add-user-btn').show()
        $('#add-user').empty()
      error: (e)->
        switch e.status
          when 401
            alertify.error("操作失败，未授权");
          when 404
            alertify.error("操作失败，查不此人");
          when 409
            alertify.error("操作失败，您可能添加了已经存在的用户");

  removeUser: (e)->
    username = $(e.target).parents('li').data('username')
    _this = @
    alertify.set labels: {
      ok     : "确定"
      cancel : "取消"
      }
    alertify.confirm "确定将 #{username} 从小组中移除?", (e)->
      if e
        $.ajax 
          url: "/api/v1/groups/#{_this.opts.id}/remove_user"
          type: "PUT"
          data: 
            username: username
          headers:
            'Auth-Token': _this.account.get('auth_token')
          success: (data)->
            alertify.success("成功移除 #{username}")
            $('#user-list').find("li[data-username=#{username}]").remove()
          error: (e)->
            switch e.status
              when 401
                alertify.error("操作失败，未授权");
              when 404
                alertify.error("操作失败，查不此人");
              when 403
                alertify.error("操作失败，您无法尝试删除管理员");
              when 409
                alertify.error("操作失败，您可能添加了已经存在的用户");
      else 
        return

  cancelAddUser: ->
    $('#add-user-btn').show()
    $('#add-user').empty()
    
  saveMeta: ->

