Coreading.Views.Articles ||= {}

class Coreading.Views.Articles.ArticlesView extends Backbone.View
  el: $('#main-content')

  initialize: (opts)->
    @articles = new Coreading.Collections.Articles(opts)
    @renderArticles()

  renderArticles: ->
    @articles.each(@renderArticle, @)

  renderArticle: (article)->
    if article.get('language') == 'markdown'
      snip = @strip(article.get('body'))
    else
      snip = @strip(article.get('body'))
    snip = @limit(snip, 300)
    article = article.toJSON()
    article.body = snip
    $('#y-articles').append(_.template($('#t-article').html())(article: article))

  strip: (html)->
    tmp = document.createElement("DIV")
    tmp.innerHTML = html
    tmp.textContent || tmp.innerText || ""

  limit: (text, num)->
    if text.length >= num
      snip = text.substr(0,num)
      snip = snip.concat('...')
    else
      snip = text
    snip
