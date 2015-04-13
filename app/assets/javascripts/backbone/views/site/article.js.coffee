Coreading.Views.Articles ||= {}

class Coreading.Views.Articles.ArticleView extends Backbone.View
  el: '#main-content'

  initialize: (opts)->
    @article = new Coreading.Models.Article(opts)
    @renderArticle()

  renderArticle: =>
    article = @article.toJSON()
    @$el.html(_.template($('#t-article-show').html())(article: article)) 
