class Coreading.Models.Article extends Backbone.Model
  defaults:
    title: ""
    body: ""
    id : ""
    tag_id: ""
    user_id: ""

  sync: Coreading.Common.api_sync

  urlRoot: "#{Coreading.ApiPrefix}/blogs"

  idAttribute: "id"

  isNew: ->
    !!@get('newbl')

class Coreading.Collections.Articles extends Backbone.Collection
  model: Coreading.Models.Article
  url: "#{Coreading.ApiPrefix}/blogs"

  sync: Coreading.Common.api_sync

  initialize: ->
    @unsync = true
    mute_unsync = ->
      @unsync = false
    @once('sync', mute_unsync, @)
