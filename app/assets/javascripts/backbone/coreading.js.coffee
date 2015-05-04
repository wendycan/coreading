#= require_self
#= require ./views/base
#= require_tree ./models
#= require ./views/annotator
#= require_tree ./common
#= require_tree ./views
#= require_tree ./routers

window.Coreading =
  Common: {}
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  ApiPrefix: "/api/v1"
  ajax: (settings = {})->
    opts =
      crossDomain: true
    $.ajax(_.extend(opts, settings))

_.templateSettings =
  escape: /\{\{-([\s\S]+?)\}\}/g
  interpolate: /\{\{=([\s\S]+?)\}\}/g
  evaluate: /\{\{([\s\S]+?)\}\}/g
