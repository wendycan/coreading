Coreading.Views.Articles ||= {}

class Coreading.Views.Articles.ArticleView extends Backbone.View
  el: '#main-content'

  initialize: (opts)->
    @article = new Coreading.Models.Article(opts)
    console.log @article
    @account = new Coreading.Models.Account
    @renderArticle()

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

  renderArticle: ->
    article = @article.toJSON()
    if article.path_type == 'online'
      @$el.html(_.template($('#t-article-show').html())(article: article)) 
    else
      @$el.html(_.template($('#t-article-pdf-show').html())(article: article)) 
      
      container = document.getElementById('pdf-viewer-container')
      pdfViewer = new PDFJS.PDFViewer({
        container: container
      })
      container.addEventListener 'pagesinit', ->
        pdfViewer.currentScaleValue = 'page-width'
      PDFJS.getDocument(article.pdf_url).then (pdfDocument)->
        pdfViewer.setDocument(pdfDocument)
        
      # container.addEventListener 'pagesloaded', ->
      #   alert('aa')
      @fetchAccount =>
        Annotator.textSelector($('#pdf-viewer-container'), {article: article, account: @account.toJSON()});
      , =>
        console.log('error')

      Annotator.hoveHighlights();
      setTimeout(Annotator.load, 3000); #tmp
      # Annotator.load();
    if article.public == 1
      $('#annotaions-meta').html _.template($('#t-annotation-meta').html())()
