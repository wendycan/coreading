Coreading.Views.Blogs ||= {}

class Coreading.Views.Blogs.BlogView extends Backbone.View
  el: $('#main-content')

  initialize: (opts)->
    @blog = new Coreading.Models.Blog(opts)
    @converter = new Showdown.converter()
    @renderBlog()

  renderBlog: ->
    blog = @blog.toJSON()
    if blog.language == 'markdown'
      blog.body = @converter.makeHtml(blog.body)
    blog.date = jQuery.timeago(blog.created_at)
    @$el.html(_.template($('#t-blog-show').html())(blog: blog)) 
